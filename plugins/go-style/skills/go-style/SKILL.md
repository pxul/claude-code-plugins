---
name: go-style
description: House Go style rules. Apply when writing or editing Go code — covers interface placement (declare where consumed), error handling (sentinels and wrapping), doc comments, struct field comments, testing conventions (public interface, testify, testdata fixtures), logging with slog, acronyms in names, benchmarking, and line splitting. Use on any Go authoring or review task.
---

# Go style

House Go conventions. Apply when writing or editing Go code, and when reviewing it. These are style rules, not correctness rules; where they conflict with a project's own documented conventions, the project wins.

1. **Benchmarking:** Use the `b.Loop()` syntax for benchmark loops where appropriate (Go 1.24+). Prefer `for b.Loop() { ... }` instead of `for i := 0; i < b.N; i++ { ... }`.

2. **Splitting long lines:** When breaking long lines (e.g. function calls), put each argument on its own line, with the first argument on the line after the opening parenthesis. Observe where practical:

```go
assert.NotEqual(
	t,
	reflect.ValueOf(orig).Pointer(),
	reflect.ValueOf(clone).Pointer(),
	"Clone should be a new instance, not the same pointer as original",
)
```

3. **Struct field comments:** Document struct members with trailing (post) comments on the same line as the field, not with a comment block on the line above each field. Keep them concise. Type- and func-level doc comments still follow https://go.dev/doc/comment (full sentences, begin with the symbol name, on the preceding line).

```go
type Command struct {
	Name   string    // executable to run, e.g. "git"
	Args   []string  // arguments passed to the executable
	Stdout io.Writer // receives stdout; nil discards
}
```

4. **Lean doc comments:** Keep doc comments focused and lean — the shortest text that conveys the contract, usually one or two sentences. Cut restatement and obvious detail; let documented struct fields carry per-field detail rather than repeating it in the type doc. Doc comments still follow https://go.dev/doc/comment (full sentences, begin with the symbol name).

5. **Errors — sentinels and wrapping, never strings:** When your package originates an error condition a caller might branch on, define an exported sentinel (`var ErrX = errors.New("pkg: ...")`) or a typed error, and have callers distinguish it with `errors.Is`/`errors.As` — never by matching on `err.Error()`. When adding context to another error you are propagating, wrap it with `fmt.Errorf("...: %w", err)` so the chain stays inspectable. Plain `errors.New` is fine in tests as a comparison token.

6. **Test fixtures in testdata:** When a test's input is a sizeable structured document (TOML, JSON, YAML, golden output, etc.), put it in a `testdata/<name>.<ext>` fixture file and read it in, rather than embedding a large raw string literal. Go ignores `testdata/` directories, and a real file gets editor syntax highlighting. Keep expected values as explicit literals in the test body; favour parse APIs that take an `io.Reader` so fixtures drop straight in.

7. **Test assertions use testify:** Use `github.com/stretchr/testify` for assertions, consistent with the wider codebase — `require` for preconditions that should stop the test (`require.NoError`, `require.ErrorIs`, `require.Len`) and `assert` for value checks (`assert.Equal`, `assert.ElementsMatch`, …). Prefer `assert.Equal(t, want, got)` over `reflect.DeepEqual`; it gives a readable diff. Keep tests table-driven where it fits.

8. **Multi-line expected values use raw string literals:** Write multi-line expected/golden values (rendered files, generated output, etc.) as raw string literals (backticks) with real newlines and tabs, not as `"line\n" + "line\n"` concatenations — the literal shows the output verbatim as it will appear, and the concatenated form is noisy and hard to read. For genuinely large structured documents, prefer a `testdata/` fixture per rule 6.

9. **Unused method receiver is a smell — prefer a free function:** If a method never touches its receiver, convert it to a free function rather than documenting the inconsistency. The unused receiver advertises a dependency or seam the code doesn't actually use (e.g. `func (a App) loadConfig(...)` reading via `os.Open` while `App.FS` goes untouched); dropping it removes what reads as inconsistent, whereas a doc comment only annotates the symptom. Companion rule: keep struct field doc comments honest about what the field is actually used for — don't let them advertise a path (e.g. a read) the field doesn't own.

10. **Declare interfaces where they are consumed:** An interface belongs in the package that calls it, named and sized for what that consumer needs; the implementing package exports concrete types (`func NewCrypto() *Crypto`), never an interface for itself. Do not declare an interface next to its implementation for mocking or "future flexibility" — an interface earns its place when a consumer must accept more than one implementation. A shared library may declare one interface on behalf of its many consumers, but the implementor never owns it. Keep interfaces small: only the methods the consumer actually calls.

11. **Test the public interface:** Write tests against the package's public API, not internal or backend implementation details.

12. **Log with `slog`:** Use the standard library's `log/slog` for structured logging where it helps observability (important decisions, errors, state changes). Do not log trivial paths.

13. **Capitalise acronyms and initialisms in names:** Keep them in full caps in variable, type and field names: `UserID` not `UserId`, `yAPD` not `yApd`.
