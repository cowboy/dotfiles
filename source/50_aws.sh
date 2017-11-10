# List all clusters for the current role
function aws_clusters() {
  aws ecs list-clusters | jq -r '.clusterArns|map((./"/")[1])|.[]'
}

# List all services for the specified cluster
function aws_services() {
  aws ecs list-services --cluster $1 | jq -r '.serviceArns|map((./"/")[1])|.[]'
}

# List all services by cluster for the current role
function aws_services_clusters() {
  local clusters services
  clusters=($(aws_clusters))
  for c in "${clusters[@]}"; do
    services=($(aws_services $c))
    for s in "${services[@]}"; do
      echo "$c $s"
    done
    [[ ${#services[@]} > 0 ]] && echo
  done
}

# List all aws tasks for the given cluster and service
function aws_tasks() {
  aws ecs list-tasks --cluster $1 --service-name $2 \
    | jq -r '.taskArns|map((./"/")[1])|.[]'
}

# List task definitions for all running tasks for the given cluster and service
function aws_describe_tasks() {
  local t=$(aws ecs describe-tasks --cluster $1 --tasks $(aws_tasks $1 $2))
  echo $t | jq -r '.tasks|map((.taskDefinitionArn/"/")[1])|.[]'
}

# Return the current task definition for the given cluster and service
function aws_describe_task_definition() {
  local tds=($(aws_describe_tasks $1 $2 | uniq))
  shift 2
  for td in "${tds[@]}"; do
    aws ecs describe-task-definition --task-definition $td | jq "$@"
  done
}

# Print out VAR=VALUE lines for env of the current task definition for the given
# cluster and service
function aws_describe_task_definition_env() {
  aws_describe_task_definition $1 $2 \
    -r '.taskDefinition.containerDefinitions[0].environment|map(.name+"="+.value)|.[]'
}

# Stop all aws tasks for the given cluster and service
function aws_stop() {
  local tasks count cluster pad s t
  cluster=$1; shift
  for s in "$@"; do
    [[ "$pad" ]] && echo; pad=1
    echo "Finding tasks for service <$s> on cluster <$cluster>"
    tasks=($(aws_tasks $cluster $s))
    count=${#tasks[@]}
    if [[ $count == 0 ]]; then
      echo "No tasks found, skipping"
      continue
    fi
    echo "${#tasks[@]} task(s) found"
    for t in "${tasks[@]}"; do
      echo "Stopping task $t"
      aws ecs stop-task --cluster $cluster --task $t --query 'task.stoppedReason' --output=text
    done
  done
}

# Log info lines to stderr
function info() {
  local prefix=$1; shift
  echo "[$prefix] $@" 1>&2
}

# aws logs get-log-events --log-group-name tech-products/precision-enrollment-worker --log-stream-name v2.1.0/precision-enrollment-worker/f29fdf40-708b-43d0-8b2a-1d2501f17f0c --start-time 1506964074570 --limit 5
function aws_logs() {
  local token text line next_token
  local group_name=$1; shift
  local stream_name=$1; shift
  [[ "$1" ]] && token="--next-token $1"
  text=$(
    aws logs get-log-events --log-group-name $group_name --log-stream-name $stream_name \
    --query '[nextForwardToken,events[*].[timestamp,message]]' \
    --output text $token \
    --start-from-head
  )
  while read -r line; do
    if [[ ! "$next_token" ]]; then
      next_token="$line"
    else
      local parts=($line)
      printf "[%(%F %T)T] ${parts[*]:1}\n" $((${parts[0]}/1000))
    fi
  done <<< "$text"
  if [[ "$next_token" != "$1" ]]; then
    info LOG "Fetching more..."
    aws_logs $group_name $stream_name $next_token
  else
    info LOG "Done!"
  fi
}
