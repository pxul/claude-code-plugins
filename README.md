# Claude Code plugins

A [Claude Code](https://code.claude.com) plugin marketplace holding my writing, documentation, and Go conventions as skills. This repo is both the **marketplace** (the catalogue Claude Code reads) and the **home of the plugins** themselves.

## Available plugins

| Plugin | What it does |
|---|---|
| `code-review` | `/code-review:review` — the house code review: a summary and findings grouped by severity (Critical, Major, Minor, Nitpick), written to `<branch>-review-<NN>-<short-hash>.md` in the project root, with a focus on correctness, safety, tests, types and dead code. |
| `core-rules` | Working rules added to every prompt by a hook rather than a skill, since they must always apply: TDD one test at a time, one plan step at a time, stop and ask about changes the plan does not cover, and change nothing after a `question:` prefix. |
| `doc-conventions` | `/doc-conventions:doc-conventions` — ADR title and status format, working-note Lifespan lines, Mermaid diagram conventions, the specification/implementation-notes document set, and OpenAPI/AsyncAPI contract conventions. |
| `go-style` | `/go-style:go-style` — the house Go style: interface placement (declare where consumed), error handling, doc and struct-field comments, testify and testdata conventions, and more. |
| `grill-with-docs` | `/grill-with-docs:grill-with-docs` — a relentless interview to sharpen a plan or design, producing the specification, ADRs, glossary entries, and implementation notes as it goes. Bundles the `grilling` and `domain-modeling` skills it drives, and `to-issues` for breaking a specification into vertical-slice issues. Adapted from Matt Pocock's [mattpocock/skills](https://github.com/mattpocock/skills). |
| `house-rules` | Style rules added to every session by a hook rather than a skill, since they must always apply: British English, lean and plain prose, markup conventions (backticked identifiers, cross-document links, lists), and formatting (24-hour times, no em dashes, no hard-wrapping). |
| `project-planning` | `/project-planning:project-planning` — the house planning conventions: `backlog.md` (Claude's work, most important first, with a Recurring section for its repeating work), `history.md` (each session's decisions), the user's actions in their to-do app, a hub project that plans across projects, project briefs, and plans that state the current position. Your own instructions name the to-do app and its skill (such as `things3`) and the hub project. `/project-planning:join-hub` brings a project into the hub. A session-start hook asks for any uncommitted `backlog.md` change, such as items the hub added, to be committed first; it does nothing in a project without one. |
| `stack-diff-doc` | `/stack-diff-doc:create-stack-diff-doc` — writes a planning doc (`issue-<slug>.md`) for one diff in a stacked-diff workflow: an issue title and body, a branch slug, and a git-spice-ready commit message. |
| `things3` | `/things3:things3` — reads and changes Things3 through AppleScript: the Inbox, Today, Upcoming, Anytime, Someday and Logbook lists, areas, projects, to-dos, when dates, deadlines and tags. Needs macOS with Things3 installed; macOS asks once for permission for the terminal to control Things3. |
| `work-item-briefs` | `/work-item-briefs:create-work-item-briefs` — writes the two higher-altitude descriptions of a whole piece of work: an epic brief (`epic-<slug>.md`, brief technical) and a business brief (`business-<slug>.md`, for a product tracker such as Jira). |

The skills refer to each other (`stack-diff-doc` writes in the `house-rules` prose style, for example), so they work best installed together. The `all` plugin installs the whole set in one go.

## Getting started

Run these from your shell. Add the marketplace once per machine:

```
claude plugin marketplace add pxul/claude-code-plugins
```

Install the whole set:

```
claude plugin install all@pxul-plugins
```

`all` adds no skills of its own. It lists every other plugin as a dependency, so installing it installs them all.

Or install a single plugin:

```
claude plugin install go-style@pxul-plugins
```

Inside a Claude Code session, `/plugin install all@pxul-plugins` opens the plugin's details, where you choose a scope before it installs. `/plugin` → **Discover** lists every plugin in the marketplace to pick from.

Skills are namespaced by their plugin (`/go-style:go-style`), and most also trigger automatically when a task matches their description. `grill-with-docs`, `to-issues` and `join-hub` run only when invoked by name.

## Updating

In a Claude Code session, go to `/plugin` → **Marketplaces** → `pxul-plugins` and choose **Update marketplace**. This refreshes the listing and updates the plugins installed from it, including any new dependencies of `all`.

Or choose **Enable auto-update** on the same screen. Plugins are versioned by git commit, so every push to `main` is an update.

## Testing locally

Load every plugin from a checkout for one session, without installing anything:

```
claude --plugin-dir ./plugins
```

Or install from the checkout as a marketplace. It registers under the same name, `pxul-plugins`, so remove any existing `pxul-plugins` marketplace first:

```
claude plugin validate .
claude plugin marketplace add ./
claude plugin install all@pxul-plugins
```

A marketplace added from a local folder reads the plugin files from that folder. Edits take effect at the next session start, or after `/reload-plugins` in an open session. To switch back to GitHub, run `claude plugin marketplace remove pxul-plugins`, which also uninstalls its plugins, then follow [Getting started](#getting-started).

## Repository layout

```
claude-code-plugins/
├── .claude-plugin/
│   └── marketplace.json          # marketplace catalogue
└── plugins/
    └── <plugin-name>/
        ├── .claude-plugin/
        │   └── plugin.json       # plugin manifest
        └── skills/
            └── <skill-name>/
                └── SKILL.md      # the skill
```

A new plugin needs its directory under `plugins/`, an entry in `marketplace.json` with a relative `source` (`./plugins/<plugin-name>`), and its name added to the `dependencies` of `plugins/all/.claude-plugin/plugin.json`. A new skill in an existing plugin needs only its `skills/<skill-name>/SKILL.md`.

## Licence

[MIT](LICENSE). The `grill-with-docs` skills are adapted from [mattpocock/skills](https://github.com/mattpocock/skills), also MIT; see [ATTRIBUTION.md](plugins/grill-with-docs/ATTRIBUTION.md).
