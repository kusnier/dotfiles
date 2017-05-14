function port -d "List processes listening on specific ports"
  sudo lsof -iTCP:$argv[1] -sTCP:LISTEN
end
