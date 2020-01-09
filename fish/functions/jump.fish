function jump
	set -l target $argv[1]
  set -l workspace_dir ~/Workspace
  set -l parts (string split "/" $target)

  if test -z $target
    cd $workspace_dir
    return
  end

  if test -z $parts[2]
    set -l dir $workspace_dir/$parts[1]

    if not test -d $dir
      mkdir -p $dir
    end

    cd $dir

    return
  end

  if test -n $parts[2]
    set dir $workspace_dir/$target

    if not test -d $dir
      mkdir -p $dir
      git clone --recursive git@github.com:$target $dir
      cd $dir
      git remote remove origin
      git remote add origin git@github.com:$target
    end

    cd $dir
    return
  end
end
