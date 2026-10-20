# Claude Code plugins

A [Claude Code](https://code.claude.com) plugin marketplace holding my writing, documentation, and Go conventions as skills. This repo is both the **marketplace** (the catalogue Claude Code reads) and the **home of the plugins** themselves.

## Available plugins

| Plugin | What it does |
|---|---|
| `lean-prose` | `/lean-prose:write-lean-prose` — the house prose style: lean, plainly worded text for documentation, commit messages, pull/merge request descriptions, issue bodies, and comments. |
| `markup-style` | `/markup-style:markup-style` — the house markup conventions: backtick code identifiers and repository/module/package names (including possessives), cross-document links, and lists. |
| `british-english` | `/british-english:british-english` — British English spelling everywhere, including code identifiers. |
| `doc-conventions` | `/doc-conventions:doc-conventions` — ADR title and status format, working-note Lifespan lines, Mermaid diagram conventions, the specification/implementation-notes document set, and OpenAPI/AsyncAPI contract conventions. |
| `go-style` | `/go-style:go-style` — the house Go style: interface placement (declare where consumed), error handling, doc and struct-field comments, testify and testdata conventions, and more. |
| `stack-diff-doc` | `/stack-diff-doc:create-stack-diff-doc` — writes a planning doc (`issue-<slug>.md`) for one diff in a stacked-diff workflow: an issue title and body, a branch slug, and a git-spice-ready commit message. |
| `work-item-briefs` | `/work-item-briefs:create-work-item-briefs` — writes the two higher-altitude descriptions of a whole piece of work: an epic brief (`epic-<slug>.md`, brief technical) and a business brief (`business-<slug>.md`, for a product tracker such as Jira). |
| `grill-with-docs` | `/grill-with-docs:grill-with-docs` — a relentless interview to sharpen a plan or design, producing the specification, ADRs, glossary entries, and implementation notes as it goes. Bundles the `grilling` and `domain-modeling` skills it drives, and `to-issues` for breaking a specification into vertical-slice issues. Adapted from Matt Pocock's [mattpocock/skills](https://github.com/mattpocock/skills). |

The skills refer to each other — `stack-diff-doc` writes in `lean-prose` style, for example — so they work best installed together.

## Getting started

Add the marketplace once per machine, in a Claude Code session:

```
/plugin marketplace add pxul/claude-code-plugins
```

Install a plugin:

```
/plugin install lean-prose@pxul
```

Or install the whole set:

```
/plugin install lean-prose@pxul
/plugin install markup-style@pxul
/plugin install british-english@pxul
/plugin install doc-conventions@pxul
/plugin install go-style@pxul
/plugin install stack-diff-doc@pxul
/plugin install work-item-briefs@pxul
/plugin install grill-with-docs@pxul
```

`/plugin` → **Discover** also lists every plugin in the marketplace to pick from.

Skills are namespaced by their plugin (`/lean-prose:write-lean-prose`), and most also trigger automatically when a task matches their description. `grill-with-docs` and `to-issues` run only when invoked by name.

## Updating

```
/plugin marketplace update pxul
```

Or enable auto-update via `/plugin` → **Marketplaces** → `pxul` → **Enable auto-update**. Plugins are versioned by git commit, so every push to `main` is an update.

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

A new plugin needs its directory under `plugins/` and an entry in `marketplace.json` with a relative `source` (`./plugins/<plugin-name>`). A new skill in an existing plugin needs only its `skills/<skill-name>/SKILL.md`.

## Licence

[MIT](LICENSE). The `grill-with-docs` skills are adapted from [mattpocock/skills](https://github.com/mattpocock/skills), also MIT; see [ATTRIBUTION.md](plugins/grill-with-docs/ATTRIBUTION.md).
