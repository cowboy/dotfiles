
# Get currently logged in aws account name
function aws-account() {
  aws iam list-account-aliases | jq ".AccountAliases[0]" -r
}

# List all clusters for the current role
function aws-list-clusters() {
  aws ecs list-clusters | jq -r '.clusterArns|map((./"/")[1])|.[]'
}

# List all services for the specified cluster
function aws-list-services() {
  aws ecs list-services --cluster $1 | jq -r '.serviceArns|map((./"/")[1])|.[]'
}

# List all services by cluster for the current role
function aws-list-services-by-cluster() {
  local clusters services
  clusters=($(aws-list-clusters))
  for c in "${clusters[@]}"; do
    services=($(aws-list-services $c))
    for s in "${services[@]}"; do
      echo "$c $s"
    done
    [[ ${#services[@]} > 0 ]] && echo
  done
}

# List all aws tasks for the given cluster and service
function aws-list-tasks() {
  aws ecs list-tasks --cluster $1 --service-name $2 \
    | jq -r '.taskArns|map((./"/")[1])|.[]'
}

# List task definitions for all running tasks for the given cluster and service
function aws-list-task-definitions() {
  local t=$(aws ecs describe-tasks --cluster $1 --tasks $(aws-list-tasks $1 $2))
  echo $t | jq -r '.tasks|map((.taskDefinitionArn/"/")[1])|.[]'
}

# Return the current task definition for the given cluster and service
function aws-task-definition() {
  local tds
  if [[ "$1" =~ : ]]; then
    tds=($1)
  else
    tds=($(aws-list-task-definitions $1 $2 | uniq))
    shift
  fi
  shift
  for td in "${tds[@]}"; do
    aws ecs describe-task-definition --task-definition $td | jq "$@"
  done
}

# List all diffs over time for a given task definition env vars
function aws-task-definition-env-history() {
  local cur=$2 max=$3 next diff a b
  [[ ! "$cur" ]] && cur=0
  [[ ! "$max" ]] && max=9999
  if [[ $(($cur+1-1)) != "$cur" || $(($max+1-1)) != "$max" ]]; then
    echo "Usage: aws-task-definition-env-history td-name [start-rev] [end-rev]"
    return 1
  fi
  while [[ $cur != $max ]]; do
    next=$((cur+1))
    b=$(aws-task-definition-env $1:$next 2>/dev/null | sort)
    if [[ ! "$b" ]]; then
      echo "No more revisions."
      return
    fi
    a=
    if [[ $cur != 0 ]]; then
      echo -ne "\rComparing revisions $cur and $next..." 1>&2
      a=$(aws-task-definition-env $1:$cur 2>/dev/null | sort)
    fi
    diff=$(diff <(echo "$a") <(echo "$b"))
    if [[ "$diff" ]]; then
      echo -ne '\r' 1>&2
      if [[ $cur == 0 ]]; then
        echo "Initial values"
      else
        echo "Differences between revisions $cur and $next"
      fi
      echo "-------------------------------------------"
      echo "$diff"
      echo "==========================================="
    fi
    cur=$((cur+1))
  done
}

# Print out VAR=VALUE lines for env of the current task definition for the given
# cluster and service
function aws-task-definition-env() {
  aws-task-definition "$@" \
    -r '.taskDefinition.containerDefinitions[0].environment|map(.name+"="+.value)|.[]'
}

# Stop all aws tasks for the given cluster and service
function aws-stop-tasks() {
  local tasks count cluster pad s t
  cluster=$1; shift
  for s in "$@"; do
    [[ "$pad" ]] && echo; pad=1
    echo "Finding tasks for service <$s> on cluster <$cluster>"
    tasks=($(aws-list-tasks $cluster $s))
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
function aws-logs() {
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
