# abbr --add !! --position anywhere (echo $history[1]) 

function bind_bang
    switch (commandline --current-token)[-1]
    case "!"
        # Without the `--`, the functionality can break when completing
        # flags used in the history (since, in certain edge cases
        # `commandline` will assume that *it* should try to interpret
        # the flag)
        commandline --current-token -- $history[1]
        commandline --function repaint
    case "*"
        commandline --insert !
    end
end

function bind_dollar
    switch (commandline --current-token)[-1]
    # This case lets us still type a literal `!$` if we need to (by
    # typing `!\$`). Probably overkill.
    case "*!\\"
        # Without the `--`, the functionality can break when completing
        # flags used in the history (since, in certain edge cases
        # `commandline` will assume that *it* should try to interpret
        # the flag)
        commandline --current-token -- (echo -ns (commandline --current-token)[-1] | head -c '-1')
        commandline --insert '$'
    case "!"
        commandline --current-token ""
        commandline --function history-token-search-backward


    # Main difference from referenced version is this `*!` case
    # =========================================================
    #
    # If the `!$` is preceded by any text, search backward for tokens
    # that contain that text as a substring. E.g., if we'd previously
    # run
    #
    #   git checkout -b a_feature_branch
    #   git checkout master
    #
    # then the `fea!$` in the following would be replaced with
    # `a_feature_branch`
    #
    #   git branch -d fea!$
    #
    # and our command line would look like
    #
    #   git branch -d a_feature_branch
    #
    case "*!"
        # Without the `--`, the functionality can break when completing
        # flags used in the history (since, in certain edge cases
        # `commandline` will assume that *it* should try to interpret
        # the flag)
        commandline --current-token -- (echo -ns (commandline --current-token)[-1] | head -c '-1')
        commandline --function history-token-search-backward
    case "*"
        commandline --insert '$'
    end
end

function fish_user_key_bindings
    bind ! bind_bang
    bind '$' bind_dollar
end
