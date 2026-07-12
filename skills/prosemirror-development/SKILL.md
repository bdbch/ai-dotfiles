---
name: "prosemirror-development"
description: "Build rich text editors with ProseMirror — EditorState, transactions, schema design, plugins, node views, decorations, commands, key bindings, input rules, history, and collaborative editing."
---

# ProseMirror Development

> Build rich text editors with ProseMirror — EditorState, transactions, schema design, plugins, node views, decorations, commands, key bindings, input rules, history, and collaborative editing.

## When to use

Use this skill when working with ProseMirror: creating or modifying editor schemas, writing plugins, implementing custom node views or decorations, defining commands or key bindings, setting up input rules, managing undo history, or implementing collaborative editing.

## Core architecture

ProseMirror is organized around a few core concepts that govern everything:

- **Immutable document tree** — The document is a persistent `Node` tree (`prosemirror-model`). Changes produce new nodes, sharing structure with the old.
- **State-driven** — All editor state lives in a single `EditorState` object (`prosemirror-state`). The only way to change state is to apply a `Transaction`.
- **Transactions build on Steps** — A `Transaction` is a `Transform` that bundles atomic `Step` objects (`prosemirror-transform`). Each step can be inverted for undo, mapped for position tracking, and rebased for collaboration.
- **Schema defines what's allowed** — Every document conforms to a `Schema` that declares which node types, mark types, and content structures are valid.
- **Plugins extend behavior** — Plugins add props (event handlers), state fields, transaction filtering, and view lifecycle hooks.

## prosemirror-model

The data layer: documents, schemas, parsing, and serialization.

### Document structure

- **`Node`** — Immutable tree node. Has `type`, `attrs`, `content` (a `Fragment`), and `marks`. Key methods: `resolve(pos)` → `ResolvedPos`, `slice(from, to)` → `Slice`, `replace(from, to, slice)`, `nodesBetween(from, to, f)`, `textBetween(from, to)`.
- **`Fragment`** — Immutable ordered list of child nodes. Methods: `cut(from, to)`, `append(other)`, `replaceChild(index, node)`, `addToStart/End(node)`.
- **`Mark`** — Non-document node annotation (emphasis, link, etc). Stored on inline nodes. Types control exclusivity via `excludes`. `Mark.sameSet(a, b)` compares sets.
- **`Slice`** — A fragment with `openStart`/`openEnd` depth. Represents a cut or copied piece that can be re-inserted. `Slice.maxOpen(fragment)` auto-computes openness.
- **`ResolvedPos`** — The result of `Node.resolve(pos)`. Provides `depth`, `parent`, `node(depth)`, `index(depth)`, `start/end/before/after(depth)`, `marks()`, `nodeBefore/After`, `blockRange(other)`.
- **`NodeRange`** — Flat range in a single parent node. Used by transform operations like lift/wrap/join.

### Schema definition

- **`Schema`** — Constructor takes `SchemaSpec` with `nodes` and `marks` (both `OrderedMap` or plain objects). `schema.nodes` and `schema.marks` map names to typed objects. `schema.node(type, attrs, content, marks)` and `schema.text(text, marks)` create typed nodes.
- **`NodeSpec`** — Key fields: `content` (content expression string like `"paragraph block*"`), `marks` (mark restriction), `group`, `inline`, `atom`, `selectable`, `draggable`, `code`, `whitespace` (`"pre"` | `"normal"`), `defining`, `isolating`, `toDOM` → `DOMOutputSpec`, `parseDOM` → `TagParseRule[]`, `attrs`.
- **`MarkSpec`** — Key fields: `attrs`, `inclusive` (default true), `excludes` (space-separated or `"_"`), `group`, `spanning`, `code`, `toDOM` → `DOMOutputSpec`, `parseDOM`.
- **`AttributeSpec`** — Shape `{default?: any, validate?: string | fn}`.
- **Content expressions** — Strings like `"paragraph+"`, `"(heading|paragraph)*"`, `"block{1,5}"`, `"inline*"`, group references via `group` name. Match evaluated at schema creation time.
- **`ContentMatch`** — Automaton state for content validation. Methods: `matchType(type)`, `matchFragment(frag)`, `defaultType`, `fillBefore(after)`, `findWrapping(target)`. Used internally by `canReplace`, `canAppend`.

### DOM parsing & serialization

- **`DOMParser.fromSchema(schema)`** — Creates a parser from `parseDOM` rules in node/mark specs. Custom: `new DOMParser(schema, rules)`. Methods: `.parse(dom, options)`, `.parseSlice(dom, options)`.
- **`DOMSerializer.fromSchema(schema)`** — Creates serializer from `toDOM` specs. Methods: `.serializeFragment(fragment, options)`, `.serializeNode(node)`.
- **`DOMOutputSpec`** — Array form: `["tagname", {attr: "val"}, child1, 0]` where `0` is the "hole" for content. Or a `{dom, contentDOM}` object.
- **`TagParseRule`** — `{tag: "selector", node/mark: "name", getAttrs, context, consuming, priority, ...}`.
- **`StyleParseRule`** — `{style: "property[=value]", mark: "name", getAttrs, ...}`.

## prosemirror-state

The state layer: EditorState, Selection, Transaction, and Plugins.

### EditorState

- **`EditorState.create({schema, doc?, selection?, storedMarks?, plugins?})`** — Create initial state. Either `schema` (creates blank doc) or `doc` must be provided.
- **`state.doc`** — Current document.
- **`state.selection`** — Current selection.
- **`state.schema`** — Schema of the document.
- **`state.tr`** — Returns a new `Transaction` based on the state.
- **`state.apply(tr)`** — Produce a new state by applying a transaction.
- **`state.reconfigure({plugins})`** — Swap active plugins while preserving state fields that still exist.
- **`state.toJSON(pluginFields)` / `EditorState.fromJSON(config, json, pluginFields)`** — Serialization/deserialization.

### Transaction

- **`Transaction` extends `Transform`** — Adds selection tracking, stored marks, metadata, and timing.
- **`tr.selection`** / **`tr.setSelection(sel)`** — Current or explicitly set selection.
- **`tr.storedMarks`** / **`tr.setStoredMarks(marks)`** — Marks to apply to next input (null = use marks at cursor).
- **`tr.addStoredMark(mark)` / `tr.removeStoredMark(mark)`** — Modify stored marks incrementally.
- **`tr.replaceSelection(slice)`** / **`tr.replaceSelectionWith(node)`** / **`tr.deleteSelection()`** — Convenience for selection-scoped edits.
- **`tr.insertText(text, from?, to?)`** — Insert plain text.
- **`tr.setMeta(key, value)` / `tr.getMeta(key)`** — Attach metadata (by string or Plugin/PluginKey). Used by view (`"pointer"`, `"uiEvent"`, `"composition"`) and history (`"addToHistory"`).
- **`tr.scrollIntoView()`** — Request scroll after apply.
- **`tr.time`** — Timestamp.

### Selection

- **`Selection`** — Abstract base with `$anchor`, `$head`, `$from`, `$to`, `anchor`, `head`, `from`, `to`, `empty`, `ranges`. Key methods: `map(doc, mapping)`, `content()`, `replace(tr, slice)`. Static: `findFrom($pos, dir)`, `near($pos, bias)`, `atStart/End(doc)`.
- **`TextSelection`** — Standard cursor/range. `$cursor` is non-null when empty. `TextSelection.create(doc, anchor, head)`, `TextSelection.between($anchor, $head, bias)`.
- **`NodeSelection`** — Selects a single node (must have `selectable: true`). `.node` holds the node. `NodeSelection.create(doc, from)`.
- **`AllSelection`** — Selects whole document (catches edge cases text selections can't represent).
- **Custom selections** — Extend `Selection`, implement `map`, `eq`, `toJSON`. Register with `Selection.jsonID(id, class)`.

### Plugin system

- **`Command`** — `(state: EditorState, dispatch?: (tr: Transaction) => void, view?: EditorView) => boolean`. Dry-run when no `dispatch`.
- **`Plugin`** — `new Plugin(spec)`. Key spec fields:
  - `props` — View props (handlers, decorations, nodeViews, etc).
  - `state` — `StateField<T>` with `init(config, instance)`, `apply(tr, value, oldState, newState)`, optional `toJSON/fromJSON`.
  - `key` — `PluginKey` for singleton identification.
  - `view` — `(view) => PluginView` with optional `update(view, prevState)` and `destroy()`.
  - `filterTransaction` — `(tr, state) => boolean` to veto transactions.
  - `appendTransaction` — `(transactions, oldState, newState) => Transaction | null` to chain additional changes.
- **`PluginKey`** — `key.get(state)` returns the plugin instance, `key.getState(state)` returns its state field.
- **State field pattern** — Keep plugin-local state in `state: StateField`. Access via `PluginKey.getState(state)`. Use `tr.getMeta(yourKey)` to receive signals from transactions.

## prosemirror-view

The rendering layer: EditorView, NodeViews, Decorations.

### EditorView

- **Constructor** — `new EditorView(place, props)`. `place` can be a DOM node, a placement function, `{mount: element}`, or `null`.
- **Props** — `DirectEditorProps` extends `EditorProps`:
  - `state` — Required. The current `EditorState`.
  - `dispatchTransaction(tr)` — Called for each transaction. Typically: `view.updateState(view.state.apply(tr))`.
  - `plugins` — Additional plugins (no state fields allowed here; add those to the state).
  - All `EditorProps` handlers (see below).
- **Core methods** — `update(props)`, `setProps(partial)`, `updateState(state)`, `destroy()`, `focus()`, `hasFocus()`.
- **Coords** — `posAtCoords({left, top})` → `{pos, inside}`, `coordsAtPos(pos, side)`, `domAtPos(pos, side)`, `posAtDOM(node, offset, bias)`, `nodeDOM(pos)`.
- **DOM state** — `dom` (editable container), `editable`, `composing`, `dragging`, `root` (for shadow DOM).
- **Paste** — `pasteHTML(html, event?)`, `pasteText(text, event?)`, `serializeForClipboard(slice)`.

### EditorProps (event handlers and configuration)

- **Event handlers** — Each takes `(view, event)`, return `true` to indicate handled:
  - **`handleDOMEvents`** — Map of `{eventname: handler}`. Return `true` but call `preventDefault` yourself.
  - **`handleKeyDown`** / **`handleKeyPress`** — Keyboard events.
  - **`handleTextInput`** — `(view, from, to, text, defaultTr) => boolean`. Override text insertion.
  - **`handleClickOn`** / **`handleClick`** — Mouse click (clickOn is called per-node inside-out).
  - **`handleDoubleClickOn`** / **`handleDoubleClick`** — Double click.
  - **`handleTripleClickOn`** / **`handleTripleClick`** — Triple click.
  - **`handlePaste`** — `(view, event, slice) => boolean`.
  - **`handleDrop`** — `(view, event, slice, moved) => boolean`.
  - **`handleScrollToSelection`** — Return `false` to allow default scroll.
- **Configuration props**:
  - `editable(state)` — Return boolean.
  - `attributes` — Object or `(state) => object` for DOM attributes on the editor element.
  - `scrollThreshold` / `scrollMargin` — Pixel values for scroll-into-view behavior.
  - `domParser` / `clipboardParser` / `clipboardTextParser` — Override parsing.
  - `transformPastedHTML` / `transformPastedText` / `transformPasted` / `transformCopied` — Pipeline hooks.
  - `clipboardSerializer` / `clipboardTextSerializer` — Override clipboard output.
- **Display props**:
  - `nodeViews` — `{name: NodeViewConstructor}`.
  - `markViews` — `{name: MarkViewConstructor}`.
  - `decorations(state)` — Return a `DecorationSet` or null.
  - `createSelectionBetween(view, anchor, head)` — Custom selection creation.
  - `dragCopies(event)` — Override copy-vs-move during drag.

> **Resolution order**: Props from the `DirectEditorProps` are checked first, then plugins (in state order), then plugins given to the view. Handlers are called in that order until one returns `true`.

### NodeView

- **`NodeViewConstructor`** — `(node, view, getPos, decorations, innerDecorations) => NodeView`.
- **`NodeView` interface**:
  - `dom` — Required outer DOM element.
  - `contentDOM` — Optional, where ProseMirror renders children. Omit for leaf/atom nodes.
  - `update(node, decorations, innerDecorations)` — Return `true` if in-place update succeeded, `false` to force rebuild.
  - `multiType` — Set `true` to allow `update` for different node types.
  - `selectNode()` / `deselectNode()` — Custom selection styling.
  - `setSelection(anchor, head, root)` — Custom DOM selection inside the node.
  - `stopEvent(event)` — Return `true` to prevent editor from handling the event.
  - `ignoreMutation(mutation)` — Return `true` to skip re-sync on DOM changes.
  - `destroy()` — Cleanup.
- **Key rule**: Never mutate the editor's DOM directly except through `contentDOM`.

### MarkView

- **`MarkViewConstructor`** — `(mark, view, inline) => MarkView`.
- **`MarkView` interface** — Like NodeView but simpler: `dom`, `contentDOM`, `ignoreMutation`, `destroy`.

### Decorations

- **`Decoration.widget(pos, toDOM, spec?)`** — Insert a DOM node at a position. `side` controls cursor association. `key` for identity-based diffing. `marks` for mark context. `stopEvent`/`ignoreSelection` for event control.
- **`Decoration.inline(from, to, attrs, spec?)`** — Add attributes/styles to inline content range. `inclusiveStart`/`inclusiveEnd` for edge behavior.
- **`Decoration.node(from, to, attrs, spec?)`** — Add attributes to a single node (from/to must align with node boundaries).
- **`DecorationSet`** — Immutable set built from `DecorationSet.create(doc, decorations)`. Methods: `find(start, end, predicate)`, `map(mapping, doc)`, `add(doc, decorations)`, `remove(decorations)`. Static: `DecorationSet.empty`.

## prosemirror-transform

The transformation layer: steps, mapping, and document transforms.

### Steps

- **`Step`** — Abstract. Key methods: `apply(doc) → StepResult`, `invert(doc) → Step`, `map(mapping) → Step | null`, `merge(other) → Step | null`, `getMap() → StepMap`. Register custom steps with `Step.jsonID(id, class)`.
- **`ReplaceStep`** — `(from, to, slice, structure?)`. Replaces a precise range.
- **`ReplaceAroundStep`** — `(from, to, gapFrom, gapTo, slice, insert, structure?)`. Replace while moving content into the slice (for wrapping/lifting).
- **`AddMarkStep`** / **`RemoveMarkStep`** — `(from, to, mark)`. Add/remove mark on inline content.
- **`AddNodeMarkStep`** / **`RemoveNodeMarkStep`** — `(pos, mark)`. Add/remove mark on a single node.
- **`AttrStep`** — `(pos, attr, value)`. Update attribute on a node.
- **`DocAttrStep`** — `(attr, value)`. Update attribute on the document node.
- **`StepResult.ok(doc)`** / **`StepResult.fail(message)`** — Return from `Step.apply`.

### Position Mapping

- **`StepMap`** — Represents a mapping as `[start, oldSize, newSize, ...]` triples. `StepMap.empty`, `StepMap.offset(n)`.
- **`Mapping`** — Pipeline of StepMaps. Supports `appendMap`, `appendMapping`, `invert`, `slice`. `map(pos, assoc)` and `mapResult(pos, assoc)` → `{pos, deleted, deletedBefore, deletedAfter}`.
- **`Mappable`** — Interface implemented by both `StepMap` and `Mapping`.

### Transform (document operations)

- **`Transform(doc)`** — Base for building up steps. All mutating methods return `this` for chaining.
- **`tr.step(step)`** / **`tr.maybeStep(step)`** — Append a step.
- **`tr.doc`** / **`tr.before`** — Current and original document.
- **`tr.steps`** / **`tr.docs`** / **`tr.mapping`** — Access accumulated steps and maps.
- **`tr.docChanged`** — True if any steps applied.
- **`tr.replace(from, to, slice?)`** — Exact replacement.
- **`tr.replaceWith(from, to, content)`** — Replace with fragment/node/array.
- **`tr.delete(from, to)`** — Shortcut for replace with empty.
- **`tr.insert(pos, content)`** — Shortcut for replace at same position.
- **`tr.replaceRange(from, to, slice)`** / **`tr.replaceRangeWith(from, to, node)`** — WYSIWYG-style replacement that adjusts boundaries.
- **`tr.deleteRange(from, to)`** — Delete with boundary adjustment.
- **`tr.lift(range, target)`** — Lift content out of parent. Use `liftTarget(range)` to compute target.
- **`tr.join(pos, depth?)`** — Join adjacent blocks at position. Use `joinPoint(doc, pos, dir)` to find join point.
- **`tr.wrap(range, wrappers)`** — Wrap content in node types. Use `findWrapping(range, type)` to compute wrappers.
- **`tr.split(pos, depth?, typesAfter?)`** — Split node at position. Use `canSplit(doc, pos)` to check.
- **`tr.setBlockType(from, to, type, attrs?)`** — Change type of textblocks in range.
- **`tr.setNodeMarkup(pos, type?, attrs?, marks?)`** — Change node's type/attrs/marks.
- **`tr.setNodeAttribute(pos, attr, value)`** / **`tr.setDocAttribute(attr, value)`** — Quick attr changes.
- **`tr.addMark(from, to, mark)`** / **`tr.removeMark(from, to, mark?)`** — Add/remove marks on inline content.
- **`tr.addNodeMark(pos, mark)`** / **`tr.removeNodeMark(pos, mark)`** — Add/remove marks on a node.
- **`tr.clearIncompatible(pos, parentType, match?)`** — Strip content that doesn't fit a new parent type.

Helper functions (not on Transform, imported separately):
- **`replaceStep(doc, from, to, slice?)`** — Create a fitting ReplaceStep.
- **`liftTarget(range)`** — Find valid lift depth.
- **`findWrapping(range, type, attrs?, innerRange?)`** — Find valid wrapping.
- **`canSplit(doc, pos, depth?, typesAfter?)`** — Check split validity.
- **`canJoin(doc, pos)`** — Check join validity.
- **`joinPoint(doc, pos, dir?)`** — Find joinable ancestor.
- **`insertPoint(doc, pos, type)`** — Find valid insertion point near pos.
- **`dropPoint(doc, pos, slice)`** — Find valid drop point.

## prosemirror-commands

Built-in editing commands. Each is a `Command` function: `(state, dispatch?, view?) => boolean`.

- **`chainCommands(...cmds)`** — Run commands in sequence until one returns `true`.
- **`deleteSelection`** — Delete selected content.
- **`joinBackward`** / **`joinForward`** — Join with previous/next block at boundary.
- **`selectNodeBackward`** / **`selectNodeForward`** — Select preceding/following node when at boundary.
- **`joinTextblockBackward`** / **`joinTextblockForward`** — Join only with adjacent textblock.
- **`joinUp`** / **`joinDown`** — Join with sibling above/below.
- **`lift`** — Lift selected block out of parent.
- **`newlineInCode`** — Insert newline in code block.
- **`exitCode`** — Move cursor to new block after code block.
- **`createParagraphNear`** — Create empty paragraph before/after selected block node.
- **`liftEmptyBlock`** — Lift empty textblock if possible.
- **`splitBlock`** — Split parent block at cursor (deletes selection first).
- **`splitBlockAs(splitNode?)`** — Split with custom type for the new block.
- **`splitBlockKeepMarks`** — Split without clearing marks.
- **`selectParentNode`** — Select the parent of current selection.
- **`selectAll`** — Select entire document.
- **`selectTextblockStart`** / **`selectTextblockEnd`** — Move cursor to start/end of textblock.
- **`wrapIn(nodeType, attrs?)`** — Wrap selection in a block node.
- **`setBlockType(nodeType, attrs?)`** — Change textblock type in selection.
- **`toggleMark(markType, attrs?, options?)`** — Toggle a mark. `options.removeWhenPresent`, `options.enterInlineAtoms`, `options.includeWhitespace`.
- **`autoJoin(command, isJoinable)`** — Wrap a command to auto-join adjacent compatible nodes.
- **`baseKeymap`** / **`pcBaseKeymap`** / **`macBaseKeymap`** — Standard key bindings as `{key: command}` objects. Use with `keymap()` plugin.

## prosemirror-keymap

- **`keymap(bindings)`** — Create a `Plugin` from `{"Mod-b": toggleMark(schema.marks.strong), ...}`.
- **`keydownHandler(bindings)`** — Same format, returns a `handleKeyDown` handler function.
- Key syntax: `"Mod-Enter"`, `"Shift-Ctrl-Alt-Space"`. Modifiers: `Shift-`/`s-`, `Alt-`/`a-`, `Ctrl-`/`c-`/`Control-`, `Cmd-`/`m-`/`Meta-`. `Mod-` is Cmd on Mac, Ctrl elsewhere. Keys: lowercase letters (shift is implied for uppercase), `"Space"`, `"Enter"`, `"Tab"`, `"ArrowUp"`, etc.
- Multiple keymap plugins: earlier in the array have higher precedence.

## prosemirror-inputrules

- **`InputRule(regexp, handler, options?)`** — `regexp` should end with `$` (match directly before cursor). `handler` can be a replacement string or `(state, match, start, end) => Transaction | null`. Options: `undoable` (default true), `inCode` (default false), `inCodeMark` (default true).
- **`inputRules({rules})`** — Plugin factory. Takes an array of `InputRule`s.
- **`undoInputRule`** — Command to undo the last input rule effect.
- **Predefined rules**: `emDash`, `ellipsis`, `openDoubleQuote`, `closeDoubleQuote`, `openSingleQuote`, `closeSingleQuote`, `smartQuotes`.
- **`wrappingInputRule(regexp, nodeType, getAttrs?, joinPredicate?)`** — Auto-wrap textblock when pattern is typed at line start.
- **`textblockTypeInputRule(regexp, nodeType, getAttrs?)`** — Change textblock type when pattern is typed at line start (e.g., `"### "` → heading).

## prosemirror-history

- **`history({depth?, newGroupDelay?})`** — Plugin that tracks undo/redo stacks. `depth` defaults to 100, `newGroupDelay` defaults to 500ms.
- **`undo`** / **`redo`** — Standard undo/redo commands.
- **`undoNoScroll`** / **`redoNoScroll`** — Undo/redo without scroll-to-selection.
- **`undoDepth(state)`** / **`redoDepth(state)`** — Query available undo/redo count.
- **`closeHistory(tr)`** — Prevent a transaction from being grouped with the previous one.
- **`isHistoryTransaction(tr)`** — Check if a transaction was generated by the history plugin.
- Skip history per-transaction: `tr.setMeta("addToHistory", false)`.

## prosemirror-collab

- **`collab({version?, clientID?})`** — Plugin for collaborative editing.
- **`getVersion(state)`** — Last synced version.
- **`receiveTransaction(state, steps, clientIDs, options?)`** — Apply remote steps, returns a `Transaction`.
- **`sendableSteps(state)`** — Returns `{version, steps, clientID, origins}` or `null` if nothing to send.
- Usage pattern: Send `sendableSteps` to server on change, call `receiveTransaction` when server responds with steps from other clients.

## prosemirror-gapcursor

- **`gapCursor()`** — Plugin that enables cursor positioning at otherwise inaccessible places (between block nodes, at document start/end). Renders as `.ProseMirror-gapcursor` element.
- **`GapCursor`** — `Selection` subclass for gap cursor positions.
- Requires `style/gapcursor.css` from the package for visual cursor.
- Nodes can control gap cursor behavior via `allowGapCursor` in their spec, or `creatGapCursor: true` for block specs.

## prosemirror-schema-basic

- **`schema`** — A ready-made `Schema` with nodes: `doc`, `paragraph`, `blockquote`, `horizontal_rule`, `heading` (level 1-6), `code_block`, `text`, `image` (src/alt/href), `hard_break`. Marks: `link` (href/title), `em`, `strong`, `code`.
- **`nodes`** / **`marks`** — Individual spec objects you can pick/extend.
- Reuse/extend: `new Schema({nodes: basicSchema.spec.nodes.append({…}), marks: basicSchema.spec.marks})`.

## prosemirror-schema-list

- **`orderedList`** / **`bulletList`** / **`listItem`** — Node specs for lists. `orderedList` has a `order` attribute.
- **`addListNodes(nodes, itemContent, listGroup?)`** — Add `ordered_list`, `bullet_list`, `list_item` to a node map.
- **`wrapInList(listType, attrs?)`** — Command to wrap selection in a list.
- **`wrapRangeInList(tr, range, listType, attrs?)`** — Lower-level list wrapping (dry-run if `tr` is null).
- **`splitListItem(itemType)`** — Command to split a list item (Enter behavior).
- **`splitListItemKeepMarks(itemType)`** — Same but preserves marks.
- **`liftListItem(itemType)`** — Command to lift item out of list.
- **`sinkListItem(itemType)`** — Command to sink item deeper into nested list.
- List items typically have content like `"paragraph block*"` or `"paragraph (ordered_list | bullet_list)*"`.

## Common patterns

### Building a plugin

```typescript
const key = new PluginKey<MyState>("my-plugin")

const plugin = new Plugin({
  key,
  state: {
    init(config, instance) { return { count: 0 } },
    apply(tr, value, oldState, newState) {
      // Return updated state based on transaction metadata
      return value
    }
  },
  props: {
    handleKeyDown(view, event) {
      // Return true to handle
    },
    decorations(state) {
      return DecorationSet.create(state.doc, [/* ... */])
    }
  },
  view(view) {
    return {
      update(view, prevState) { /* view.state changed */ },
      destroy() { /* cleanup */ }
    }
  }
})
```

### Dispatching a custom transaction

```typescript
let tr = view.state.tr
tr.insertText("hello")
tr.setMeta("scrollIntoView", true)  // or tr.scrollIntoView()
view.dispatch(tr)
```

### Reading plugin state

```typescript
const pluginState = PluginKey.getState(state)
// or:
const plugin = key.get(state)
```

### Creating a custom node view

```typescript
const nodeViews = {
  image(node, view, getPos, decorations, innerDecorations) {
    const dom = document.createElement("div")
    dom.className = "custom-image"
    // ... set up UI
    return {
      dom,
      update(newNode) {
        if (newNode.type !== node.type) return false
        // update in-place
        return true
      },
      destroy() { /* cleanup */ }
    }
  }
}
```

### Writing a custom command

```typescript
function myCommand(state: EditorState, dispatch?: (tr: Transaction) => void, view?: EditorView): boolean {
  const canDo = /* check state */ true
  if (!canDo) return false
  if (dispatch) {
    dispatch(state.tr.replaceSelectionWith(someNode))
  }
  return true
}
```

### Creating a custom step

```typescript
class MyStep extends Step {
  apply(doc) { /* ... return StepResult.ok(newDoc) or StepResult.fail(...) */ }
  invert(doc) { /* ... */ }
  map(mapping) { /* ... */ }
  getMap() { return new StepMap([...]) }
  toJSON() { return { stepType: "myStep", ... } }
  static fromJSON(schema, json) { return new MyStep(...) }
}
Step.jsonID("myStep", MyStep)
```

## Pitfalls & gotchas

- **Immutability**: Never mutate `Node`, `Fragment`, `Mark`, or `Selection` objects. Always create new ones.
- **`state.tr` is ephemeral**: Always call `state.tr` fresh. Don't cache a transaction across state updates.
- **Plugins with state must be in the state**: If a plugin defines `state`, `filterTransaction`, or `appendTransaction`, it must be passed to `EditorState.create({plugins})`, not to the view's `plugins` prop.
- **Transform methods mutate the tr**: `tr.insert(...)` returns `this` and mutates in place. Don't reuse a `tr` after passing it to `dispatch`.
- **Node positions use the indexing scheme**: Text nodes have size equal to character count; non-leaf nodes are `size = contentSize + 2`. A leaf block node has size 1.
- **`ResolvedPos.depth` is 0 at root**: Use `$pos.depth` repeatedly with `$pos.node(depth)`, `$pos.index(depth)`, `$pos.start(depth)`, `$pos.end(depth)`.
- **`NodeView.update` must return a boolean**: Returning `true` means "I handled it in-place", returning `false` means "rebuild me". Don't forget the return value.
- **`DecorationSet.create` consumes the array**: Pass a copy if you need the original.
- **Widget decoration keys**: Use `key` in the spec for stable identity. Without a key, the DOM node identity is used, which can cause issues with dynamically generated decorations.
- **Schema validation errors**: Content expression mismatches throw at schema creation time. Use `NodeType.createAndFill` for auto-wrapping.
- **History and `addToHistory`**: Set `tr.setMeta("addToHistory", false)` for transactions that shouldn't be undoable (selection changes, cursor movements, collaboration receipts).
- **`dispatchTransaction` is called for every user interaction**: If you don't provide it, the view handles state internally. If you do, you're responsible for applying the transaction and calling `view.updateState`.
- **`someProp` iteration**: All props (event handlers, decorations, etc.) are resolved by calling `view.someProp(propName, fn)` which iterates through direct props, view plugins, and state plugins until `fn` returns truthy.
- **Transforms with `replaceRange` vs `replace`**: Use `replaceRange` for user-facing operations (paste, drag-drop) — it adjusts boundaries for WYSIWYG expectations. Use `replace` for precise programmatic changes.

## Reference

- [ProseMirror Reference Manual](https://prosemirror.net/docs/ref/)
- [ProseMirror Guide](https://prosemirror.net/docs/guide/)
- [ProseMirror Examples](https://prosemirror.net/examples/)
- [ProseMirror Discuss Forum](https://discuss.prosemirror.net/)
