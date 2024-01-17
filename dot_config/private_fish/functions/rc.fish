function rc --wraps='rsync -rauv --progress' --description 'alias rc=rsync -rauv --progress'
  rsync -rauv --progress $argv
        
end
