# I use this (optional) file to make the font larger for presentations - Cowboy

echo -n "Modifying fonts..."
css=$(cat <<'CSS'
/* === Added on `date` === */

/* LARGER fonts in WebKit Inspector */

/* Yes, this is intentional (selector specificity, etc) */
body[class*="platform-"][class*="platform-"] .monospace,
body[class*="platform-"][class*="platform-"] .source-code,
.console-group-messages .outline-disclosure,
.console-group-messages .outline-disclosure ol {
  font-size: 20px !important;
  line-height: 1.15em !important;
}

.styles-element-state-pane { margin-top: -53px !important; }
.styles-element-state-pane.expanded { margin-top: 0 !important; }

.section .header::before { top: -5px !important; }
.section {
  margin-top: 0.3em !important;
  margin-bottom: 0.5em !important;
}
CSS
)

find "$devtools_path" \( -name devTools.css \) -exec bash -c "echo '$css' >> {}" \;
echo "OK"
