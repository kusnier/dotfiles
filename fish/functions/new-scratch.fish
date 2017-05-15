# http://ku1ik.com/2012/05/04/scratch-dir.html
function new-scratch -d "Scratch dir"
  set dateString (date +'%s')
  set new_dir "/tmp/scratch-$dateString"

  if test -d /dev/shm/
      set new_dir "/dev/shm/scratch-$dateString"
  end

  set cur_dir "$HOME/scratch"
  mkdir -p $new_dir
  ln -nfs $new_dir $cur_dir
  cd $cur_dir
  echo "New scratch dir ready for grinding ;>"
end
