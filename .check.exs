[
  ## all available options with default values (see `mix check` docs for description)
  # parallel: true,
  # skipped: true,

  ## list of tools (see `mix check` docs for a list of default curated tools)
  retry: false,
  fix: true,
  tools: [
    ## curated tools may be disabled (e.g. the check for compilation warnings)
    {:sobelow, false},
    {:ex_doc, false},
    {:npm_test, false},
    {:ex_unit, command: "mix test", env: %{"MIX_ENV" => "test"}}

    ## ...or have command & args adjusted (e.g. enable skip comments for sobelow)
    # {:sobelow, "mix sobelow --exit --skip"},

    ## ...or reordered (e.g. to see output from dialyzer before others)
    # {:dialyzer, order: -1},

    ## ...or reconfigured (e.g. disable parallel execution of ex_unit in umbrella)
    # {:ex_unit, umbrella: [parallel: false]},

    ## custom new tools may be added (Mix tasks or arbitrary commands)
    # {:my_task, "mix my_task", env: %{"MIX_ENV" => "prod"}},
    # {:my_tool, ["my_tool", "arg with spaces"]}
  ]
]
