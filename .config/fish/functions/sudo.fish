function sudo --description 'sudo wrapper for handling aliases'
  for i in (seq (count $argv))
    if functions -q -- $argv[$i]
      if test $i != 1
          set sudo_args $argv[..(math $i - 1)]
      end
      command sudo $sudo_args fish -C "source $(functions --no-details (functions | string split ', ') | psub)" -c '$argv' $argv[$i..]
      return
    else if command -q -- $argv[$i]
      command sudo $argv
      return
    end
  end
  command sudo $argv
end
