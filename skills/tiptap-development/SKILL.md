---
name: "Tiptap Development"
description: "Build rich text editors with Tiptap (v3) — Editor instance, extensions, nodes, marks, commands, chaining, node views, UI integrations (React/Vue), events, keyboard shortcuts, input rules, and ProseMirror bridging."
---

# Tiptap Development

> Build rich text editors with Tiptap (v3) — Editor instance, extensions, nodes, marks, commands, chaining, node views, UI integrations (React/Vue), events, keyboard shortcuts, input rules, and ProseMirror bridging.

## When to use

Use this skill when working with Tiptap: creating or modifying editor instances, building custom extensions (nodes, marks, functionality), implementing node views (plain JS, React, or Vue), managing commands and keyboard shortcuts, handling events, configuring the StarterKit, integrating with React or Vue, or bridging to ProseMirror plugins.

## Core architecture

Tiptap is a headless wrapper around ProseMirror. Key concepts:

- **Everything is an extension** — Nodes, marks, and functionality are all extensions created with `Extension.create()`, `Node.create()`, or `Mark.create()`. They follow the same API patterns.
- **Fluent command chaining** — Commands are chained via `editor.chain().focus().toggleBold().run()`. All commands in the chain combine into a single ProseMirror transaction.
- **`can()` for dry runs** — `editor.can().toggleBold()` returns `true/false` without applying changes. Useful for enabling/disabling toolbar buttons.
- **Extension configuration** — Extensions receive options via `.configure({...})`. Access inside the extension via `this.options`.
- **ProseMirror underneath** — Tiptap exposes the full ProseMirror API through `editor.view` (EditorView), `editor.state` (EditorState), and `@tiptap/pm/*` imports.
- **Framework-agnostic core** — The core `@tiptap/core` works anywhere. Framework-specific packages (`@tiptap/react`, `@tiptap/vue-3`) provide hooks like `useEditor`.

## Editor instance

### Creating an editor

```typescript
import { Editor } from '@tiptap/core'
import StarterKit from '@tiptap/starter-kit'

const editor = new Editor({
  element: document.querySelector('.editor'),  // Optional, defer with null
  extensions: [StarterKit],
  content: '<p>Hello World</p>',               // HTML or JSON
  editable: true,
  autofocus: 'start',                          // 'start' | 'end' | 'all' | number | boolean
  textDirection: 'ltr',                        // 'ltr' | 'rtl' | 'auto'
  injectCSS: true,
  injectNonce: 'your-nonce-here',              // For CSP
  enableInputRules: true,                      // or string[] to allow specific
  enablePasteRules: true,                      // or string[] to allow specific
  editorProps: {
    // Direct ProseMirror EditorProps passthrough
    attributes: { class: 'prose focus:outline-none' },
    transformPastedText(text) { return text.toUpperCase() }
  },
  parseOptions: {
    preserveWhitespace: 'full',
  },
  coreExtensionOptions: {
    tabindex: { value: '0' },
  },
})
```

### Deferred mounting

```typescript
const editor = new Editor({
  element: null,  // Don't mount yet
  extensions: [StarterKit],
})

// Later:
editor.mount(document.querySelector('.editor'))
editor.unmount()  // Unmount without destroying
```

### Methods

| Method | Purpose |
|--------|---------|
| `editor.chain().focus().toggleBold().run()` | Execute a command chain |
| `editor.can().toggleBold()` | Dry-run check |
| `editor.commands.toggleBold()` | Execute single command |
| `editor.getHTML()` | Get content as HTML |
| `editor.getJSON()` | Get content as ProseMirror JSON |
| `editor.getText({ blockSeparator: '\n\n' })` | Get content as plain text |
| `editor.isActive('heading', { level: 2 })` | Check if node/mark is active |
| `editor.getAttributes('link')` | Get attributes of selected node/mark |
| `editor.setEditable(false)` | Toggle read-only. Second param controls `update` event |
| `editor.setOptions({ editorProps: {...} })` | Update options at runtime |
| `editor.registerPlugin(plugin, handlePlugins?)` | Register a ProseMirror plugin |
| `editor.unregisterPlugin('name')` | Unregister a plugin |
| `editor.destroy()` | Tear down the editor |

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `editor.isEditable` | `boolean` | Whether content is editable |
| `editor.isEmpty` | `boolean` | Whether document is empty |
| `editor.isFocused` | `boolean` | Whether editor has focus |
| `editor.isDestroyed` | `boolean` | Whether editor is destroyed |
| `editor.isCapturingTransaction` | `boolean` | Whether inside a chain `.run()` |
| `editor.state` | `EditorState` | Raw ProseMirror state |
| `editor.view` | `EditorView` | Raw ProseMirror view |
| `editor.schema` | `Schema` | Raw ProseMirror schema |
| `editor.storage` | `Record<string, any>` | Extension storage objects (namespaced by extension name) |

## Commands

All commands are accessible through `editor.commands.*` or `editor.chain().*.run()`. With `.can()` prefix, they return `boolean` instead of executing.

### Content commands

| Command | Description |
|---------|-------------|
| `setContent(content, emitUpdate?, parseOptions?)` | Replace entire document |
| `clearContent(emitUpdate?)` | Clear the document |
| `insertContent(value, options?)` | Insert at current position (HTML, JSON, or array) |
| `insertContentAt(position, value, options?)` | Insert at specific position |

### Node & mark commands

| Command | Description |
|---------|-------------|
| `clearNodes()` | Normalize to paragraph |
| `setNode(type, attrs?)` | Replace range with a node |
| `toggleNode(type, toggleType?, attrs?)` | Toggle between two node types |
| `toggleWrap(type, attrs?)` | Wrap/unwrap in a node |
| `setMark(type, attrs?)` | Apply a mark with attributes |
| `toggleMark(type, attrs?, options?)` | Toggle a mark on/off |
| `unsetMark(type, options?)` | Remove a mark |
| `unsetAllMarks()` | Remove all marks in selection |
| `updateAttributes(type, attrs)` | Update attributes of node/mark |
| `resetAttributes(type, attrs)` | Reset to defaults |
| `extendMarkRange(type, attrs?)` | Expand selection to cover mark |
| `deleteNode(type)` | Delete nearest node of given type |

### List commands

| Command | Description |
|---------|-------------|
| `toggleList(listType, itemType)` | Toggle between list types |
| `wrapInList(listType, attrs?)` | Wrap in a list |
| `splitListItem(itemType)` | Split a list item (Enter behavior) |
| `liftListItem(itemType)` | Lift item out of list |
| `sinkListItem(itemType)` | Sink item deeper into nested list |

### Selection commands

| Command | Description |
|---------|-------------|
| `focus(position?)` | Focus the editor |
| `blur()` | Remove focus |
| `selectAll()` | Select entire document |
| `selectParentNode()` | Select parent node |
| `setTextSelection(position)` | Set cursor/range |
| `setNodeSelection(position)` | Set node selection |
| `deleteSelection()` | Delete selected content |
| `deleteRange(range)` | Delete a given range |
| `scrollIntoView()` | Scroll selection into view |
| `enter()` | Trigger Enter behavior |

### Other commands

| Command | Description |
|---------|-------------|
| `keyboardShortcut(name)` | Execute a keyboard shortcut programmatically |
| `undoInputRule()` | Undo the last input rule |
| `setMeta(key, value)` | Set metadata on the underlying transaction |
| `command(fn)` | Execute arbitrary logic in a chain |
| `first(steps)` | Try commands in order, stop at first success |

### Chain pattern

```typescript
editor
  .chain()
  .focus()                          // Bring focus back to editor
  .toggleBold()                     // Apply bold
  .insertContent(' Hello!')         // Insert text
  .setMeta('addToHistory', false)   // Exclude from history
  .run()
```

> Inside a `.chain()`, all commands share one transaction. Use `tr.mapping.map(pos)` inside custom chained commands to map positions across steps.

### `.first()` pattern

```typescript
editor.commands.first(({ commands }) => [
  () => commands.undoInputRule(),
  () => commands.deleteSelection(),
  () => commands.selectNodeBackward(),
  () => commands.joinBackward(),
])
```

### `.can()` for toolbar state

```typescript
const canBold = editor.can().toggleBold()
const isBold = editor.isActive('bold')
```

## Extensions

All Tiptap functionality is an extension. Three base types:

| Type | Purpose | Import |
|------|---------|--------|
| `Extension` | Functionality (no schema) | `@tiptap/core` |
| `Node` | Content type (adds to schema) | `@tiptap/core` |
| `Mark` | Inline formatting (adds to schema) | `@tiptap/core` |

### Extension API (common to all types)

```typescript
import { Extension } from '@tiptap/core'

const MyExtension = Extension.create({
  name: 'myExtension',  // Required. Used for storage namespace, commands, etc.

  // Configuration
  addOptions() {
    return { foo: 'bar', HTMLAttributes: {} }
  },

  addStorage() {
    return { count: 0 }
  },

  // Lifecycle hooks
  onBeforeCreate() { /* editor.view not yet created */ },
  onCreate() { /* editor is ready */ },
  onUpdate() { /* content changed */ },
  onSelectionUpdate({ editor }) { /* selection changed */ },
  onTransaction({ editor, transaction }) { /* any state change */ },
  onFocus({ event }) { /* editor gained focus */ },
  onBlur({ event }) { /* editor lost focus */ },
  onDestroy() { /* editor is being destroyed */ },
  onPaste(event, slice) { /* content pasted */ },
  onDrop(event, slice, moved) { /* content dropped */ },
  onDelete({ type, deletedRange, newRange, ... }) { /* content deleted */ },
  onContentError({ error, disableCollaboration }) { /* schema mismatch */ },

  // Commands
  addCommands() {
    return {
      myCommand: (attrs) => ({ commands }) => {
        return commands.setContent('executed')
      },
    }
  },

  // Keyboard shortcuts
  addKeyboardShortcuts() {
    return {
      'Mod-k': () => this.editor.commands.myCommand(),
    }
  },

  // Input and paste rules
  addInputRules() {
    return [
      // Use nodeInputRule, markInputRule, textInputRule, or plain InputRule
    ]
  },
  addPasteRules() {
    return [
      // Use nodePasteRule, markPasteRule, or plain PasteRule
    ]
  },

  // ProseMirror integration
  addProseMirrorPlugins() {
    return [
      new Plugin({ key: new PluginKey('custom'), ... }),
    ]
  },

  // Global attributes (for shared styling properties)
  addGlobalAttributes() {
    return [{
      types: ['heading', 'paragraph'],  // or '*' | 'nodes' | 'marks'
      attributes: {
        textAlign: {
          default: 'left',
          renderHTML: (attrs) => ({ style: `text-align: ${attrs.textAlign}` }),
          parseHTML: (el) => el.style.textAlign || 'left',
        },
      },
    }]
  },

  // Extend schema
  extendNodeSchema() { return { customField: 'value' } },
  extendMarkSchema() { return { customField: 'value' } },

  // Paste transformation middleware
  transformPastedHTML(html) {
    return html.replace(/<script[^>]*>.*?<\/script>/gi, '')
  },

  // Transaction middleware
  dispatchTransaction({ transaction, next }) {
    console.log('before dispatch')
    next(transaction)
    console.log('after dispatch')
  },

  // Nested extensions (for bundles)
  addExtensions() {
    return [SomeExtension.configure({ ... })]
  },
})
```

### Available in `this` inside any extension

| Property | Description |
|----------|-------------|
| `this.name` | Extension name |
| `this.editor` | Editor instance |
| `this.type` | ProseMirror NodeType/MarkType (for nodes/marks) |
| `this.options` | Resolved options |
| `this.storage` | Storage object |
| `this.parent` | Parent extension's context (for `.extend()`) |

### Function callback form

Extensions also accept a callback for encapsulating logic:

```typescript
const MyExtension = Extension.create(() => {
  const privateVar = 'secret'

  return {
    name: 'myExtension',
    onCreate() { console.log(privateVar) },
    onUpdate() { /* ... */ },
  }
})
```

## Nodes

Nodes are content types (blocks like paragraphs, headings, or inline nodes like mentions). They extend the Extension API.

```typescript
import { Node } from '@tiptap/core'

const CustomNode = Node.create({
  name: 'customNode',

  // Schema properties (maps to ProseMirror NodeSpec)
  topNode: false,          // Is this the document root?
  content: 'inline*',      // Content expression ('' for no children)
  marks: '_',              // Allowed marks ('_' = all, '' = none, 'strong em' = specific)
  group: 'block',          // Group name (default: 'block')
  inline: false,           // Is this an inline node?
  atom: false,             // Treat as single unit (uneditable)?
  selectable: true,        // Can be node-selected?
  draggable: false,        // Can be dragged without selection?
  code: false,             // Contains code?
  whitespace: 'normal',    // 'normal' | 'pre'
  defining: false,         // Defines parent boundary during replace
  isolating: false,        // Blocks editing operations from crossing
  linebreakReplacement: false, // Linebreak equiv (e.g., hardBreak)

  // HTML handling
  addAttributes() {
    return {
      customAttr: {
        default: null,
        parseHTML: (el) => el.getAttribute('data-custom'),
        renderHTML: (attrs) => ({ 'data-custom': attrs.customAttr }),
      }
    }
  },

  parseHTML() {
    return [{ tag: 'div[data-type="custom"]' }]
  },

  renderHTML({ HTMLAttributes }) {
    return ['div', mergeAttributes(HTMLAttributes, { 'data-type': 'custom' }), 0]
  },

  // Node views (advanced rendering)
  addNodeView() {
    return ({ node, getPos, editor, extensions }) => {
      const dom = document.createElement('div')
      dom.contentEditable = 'false'
      dom.textContent = node.attrs.customAttr || 'default'

      return {
        dom,
        update: (updatedNode) => {
          if (updatedNode.type !== node.type) return false
          dom.textContent = updatedNode.attrs.customAttr || 'default'
          return true
        },
        destroy: () => { /* cleanup */ },
        ignoreMutation: (mutation) => true,
        stopEvent: (event) => false,
        selectNode: () => { dom.classList.add('selected') },
        deselectNode: () => { dom.classList.remove('selected') },
      }
    }
  },
})
```

### Node view types

| Type | Pattern | Example |
|------|---------|---------|
| Editable text | Set `contentDOM` + `dom` | TaskItem (checkbox + text) |
| Non-editable text | Don't set `contentDOM`, render in `dom` | Mention |
| Mixed content | Partial `contenteditable="false"` children | Complex widgets |

> **Important**: `renderHTML` is what gets serialized to HTML output (copy, getHTML, etc.). The node view is only for in-editor rendering. They can be completely different.

## Marks

Marks are inline formatting (bold, italic, links, highlights).

```typescript
import { Mark } from '@tiptap/core'

const CustomMark = Mark.create({
  name: 'customMark',

  // Mark-specific schema properties
  inclusive: true,     // Active at cursor at end of mark?
  excludes: '_',       // '_' excludes all, '' allows overlap, string names specific
  exitable: true,      // Can backspace out of the mark?
  spanning: true,      // Can span multiple nodes?
  code: false,         // Is this a code mark?
  group: 'textStyle',  // Only one mark per group active at a time
  keepOnSplit: true,   // Keep mark when splitting a node?

  addAttributes() {
    return {
      title: { default: null },
    }
  },

  parseHTML() {
    return [{ tag: 'span[data-mark="custom"]' }]
  },

  renderHTML({ HTMLAttributes }) {
    return ['span', mergeAttributes(HTMLAttributes, { 'data-mark': 'custom' }), 0]
  },
})
```

## StarterKit

`@tiptap/starter-kit` bundles essential extensions:

| Included nodes | Included marks | Included functionality |
|----------------|----------------|----------------------|
| Document, Paragraph, Text, CodeBlock, Heading, Blockquote, BulletList, OrderedList, ListItem, HorizontalRule, HardBreak | Bold, Italic, Strike, Code, Link | History, Gapcursor, Dropcursor, InputRules, PasteRules |

Configure individually:

```typescript
import StarterKit from '@tiptap/starter-kit'

StarterKit.configure({
  heading: { levels: [1, 2, 3] },
  codeBlock: false,  // Disable code block
  history: { depth: 50, newGroupDelay: 300 },
})
```

## Events

### Editor-level events

```typescript
// Via config
new Editor({
  onCreate({ editor }) { },
  onUpdate({ editor }) { },
  onSelectionUpdate({ editor }) { },
  onTransaction({ editor, transaction }) { },
  onFocus({ editor, event }) { },
  onBlur({ editor, event }) { },
  onDestroy() { },
  onPaste(event, slice) { },
  onDrop(event, slice, moved) { },
})

// Via .on()/.off() binding
const handler = ({ editor }) => console.log('updated')
editor.on('update', handler)
editor.off('update', handler)
```

### Extension-level events

Same events, but defined directly on the extension:

```typescript
Extension.create({
  name: 'logger',
  onUpdate() { console.log('content changed') },
})
```

## Keyboard shortcuts

Defined via `addKeyboardShortcuts()`:

| Modifier | Key syntax |
|----------|------------|
| Ctrl/Cmd | `Mod-` |
| Shift | `Shift-` (or implied uppercase) |
| Alt | `Alt-` |
| Meta (Cmd) | `Cmd-` / `Meta-` |

```typescript
addKeyboardShortcuts() {
  return {
    'Mod-b': () => this.editor.commands.toggleBold(),
    'Mod-Enter': () => this.editor.commands.exitCode(),
    'Shift-Enter': () => this.editor.commands.newlineInCode(),
    'Mod-k': () => this.editor.commands.setMark('link', { href: 'https://' }),
    'Escape': () => this.editor.commands.focus(),
    'Tab': () => this.editor.commands.sinkListItem('listItem'),
    'Shift-Tab': () => this.editor.commands.liftListItem('listItem'),
  }
}
```

Return `true` to indicate the shortcut was handled. Return `false` to let it bubble.

## Input rules & paste rules

### Input rules (text typing transformations)

```typescript
import { InputRule } from '@tiptap/core'

addInputRules() {
  return [
    // Replace pattern with string
    new InputRule({
      find: /--$/,
      handler: ({ state, range, match }) => {
        return state.tr.insertText('—', range.from, range.to)
      },
    }),

    // Wrapping input rule (starts with `> ` → blockquote)
    wrappingInputRule({
      find: /^\s*>\s$/,
      type: this.editor.schema.nodes.blockquote,
    }),

    // Textblock type rule (`# ` → heading)
    textblockTypeInputRule({
      find: /^##\s$/,
      type: this.editor.schema.nodes.heading,
      getAttrs: () => ({ level: 2 }),
    }),
  ]
}
```

### Paste rules (pasted content transformations)

```typescript
import { markPasteRule, nodePasteRule } from '@tiptap/core'

addPasteRules() {
  return [
    markPasteRule({
      find: /https?:\/\/[^\s]+/g,  // Note: 'g' flag for paste rules
      type: this.editor.schema.marks.link,
      getAttrs: (url) => ({ href: url }),
    }),
  ]
}
```

**Key difference**: Input rules use `$` (end of line) in regex; paste rules use `g` (global) flag.

## Framework integrations

### React

```typescript
import { useEditor, EditorContent } from '@tiptap/react'
import StarterKit from '@tiptap/starter-kit'

function Editor() {
  const editor = useEditor({
    extensions: [StarterKit],
    content: '<p>Hello!</p>',
    onUpdate: ({ editor }) => {
      // Use editor.getHTML() etc.
    },
  })

  // Toolbar: use editor?.can() for state
  return (
    <>
      <button
        onClick={() => editor?.chain().focus().toggleBold().run()}
        disabled={!editor?.can().chain().focus().toggleBold().run()}
        className={editor?.isActive('bold') ? 'is-active' : ''}
      >
        Bold
      </button>
      <EditorContent editor={editor} />
    </>
  )
}
```

### React Node Views

Create a React component for a node:

```typescript
import { ReactNodeViewRenderer } from '@tiptap/react'
import NodeViewComponent from './NodeViewComponent'

const CustomNode = Node.create({
  name: 'customNode',
  // ...attributes, parseHTML, renderHTML...
  addNodeView() {
    return ReactNodeViewRenderer(NodeViewComponent)
  },
})
```

The component receives props: `{ node, getPos, editor, updateAttributes, deleteNode, selected, extension }`.

### Vue 3

```typescript
import { useEditor, EditorContent } from '@tiptap/vue-3'

const editor = useEditor({
  extensions: [StarterKit],
  content: '<p>Hello!</p>',
})
```

### Vue Node Views

```typescript
import { VueNodeViewRenderer } from '@tiptap/vue-3'

Node.create({
  name: 'customNode',
  addNodeView() {
    return VueNodeViewRenderer(MyComponent)
  },
})
```

## ProseMirror bridging

Import ProseMirror modules via `@tiptap/pm/*`:

```typescript
import { Plugin, PluginKey } from '@tiptap/pm/state'
import { history, undo, redo } from '@tiptap/pm/history'
import { keymap } from '@tiptap/pm/keymap'
import { exitCode } from '@tiptap/pm/commands'
import { Decoration, DecorationSet } from '@tiptap/pm/view'
import { Schema } from '@tiptap/pm/model'
import { InputRule } from '@tiptap/pm/inputrules'
import { GapCursor } from '@tiptap/pm/gapcursor'

// Access from editor:
editor.view       // ProseMirror EditorView
editor.state      // ProseMirror EditorState
editor.schema     // ProseMirror Schema
editor.view.dispatch(tr)  // Raw dispatch
```

### Adding ProseMirror plugins to an extension

```typescript
addProseMirrorPlugins() {
  return [
    new Plugin({
      key: new PluginKey('my-plugin'),
      props: {
        handleKeyDown(view, event) {
          // ...
        },
        decorations(state) {
          return DecorationSet.create(state.doc, [/* ... */])
        },
      },
      view() {
        return {
          update(view, prevState) { },
          destroy() { },
        }
      },
    }),
  ]
}
```

### Extending existing extensions

```typescript
import Heading from '@tiptap/extension-heading'

const CustomHeading = Heading.extend({
  name: 'customHeading',
  addOptions() {
    return { ...this.parent?.(), levels: [1, 2, 3] }
  },
  addAttributes() {
    return { ...this.parent?.(), id: { default: null } }
  },
})
```

## Common patterns

### Bubble menu

```typescript
import BubbleMenu from '@tiptap/extension-bubble-menu'

const editor = new Editor({
  extensions: [
    StarterKit,
    BubbleMenu.configure({
      element: document.querySelector('.bubble-menu'),
      tippyOptions: { placement: 'top' },
    }),
  ],
})
```

### Floating menu

```typescript
import FloatingMenu from '@tiptap/extension-floating-menu'

FloatingMenu.configure({
  element: document.querySelector('.floating-menu'),
  shouldShow: ({ editor, state }) => editor.isActive('heading'),
})
```

### Placeholder

```typescript
import Placeholder from '@tiptap/extension-placeholder'

Placeholder.configure({
  placeholder: 'Start writing...',
  // Or a function:
  placeholder: ({ node }) => {
    if (node.type.name === 'heading') return 'Heading'
    return 'Start writing...'
  },
})
```

### Custom menu bar (vanilla JS)

```typescript
const menuItems = [
  { name: 'bold', action: () => editor.chain().focus().toggleBold().run(), isActive: () => editor.isActive('bold') },
  { name: 'italic', action: () => editor.chain().focus().toggleItalic().run(), isActive: () => editor.isActive('italic') },
]

// Update UI on selection change
editor.on('selectionUpdate', () => {
  menuItems.forEach(item => {
    button.className = item.isActive() ? 'active' : ''
    button.disabled = !editor.can().chain().focus()[item.name]().run()
  })
})
```

### Transform pasted HTML (middleware chain)

Extensions with `transformPastedHTML` form a middleware chain, sorted by `priority`:

```typescript
const SecurityExtension = Extension.create({
  name: 'security',
  priority: 110,  // Runs first
  transformPastedHTML(html) {
    return html
      .replace(/<script[\s\S]*?<\/script>/gi, '')
      .replace(/\s+on\w+\s*=\s*["'][^"']*["']/gi, '')
  },
})

const GoogleDocsCleanup = Extension.create({
  name: 'googleDocsCleanup',
  priority: 100,
  transformPastedHTML(html) {
    return html
      .replace(/<span[^>]*style="[^"]*"[^>]*>(.*?)<\/span>/gi, '$1')
      .replace(/<style[\s\S]*?<\/style>/gi, '')
  },
})
```

### DispatchTransaction middleware

```typescript
const LoggingExtension = Extension.create({
  name: 'logging',
  priority: 1000,
  dispatchTransaction({ transaction, next }) {
    console.log('Transaction:', transaction)
    next(transaction)  // Must call next() to dispatch
  },
})
```

## Built-in extensions reference

### Nodes (provided by @tiptap/*)

| Extension | Package | Key options |
|-----------|---------|-------------|
| Document | `@tiptap/extension-document` | — |
| Paragraph | `@tiptap/extension-paragraph` | — |
| Text | `@tiptap/extension-text` | — |
| Heading | `@tiptap/extension-heading` | `levels: [1,2,3,4,5,6]` |
| Blockquote | `@tiptap/extension-blockquote` | — |
| CodeBlock | `@tiptap/extension-code-block` | `languageClassPrefix` |
| CodeBlockLowlight | `@tiptap/extension-code-block-lowlight` | `lowlight` instance |
| HorizontalRule | `@tiptap/extension-horizontal-rule` | — |
| HardBreak | `@tiptap/extension-hard-break` | `keepMarks` |
| BulletList | `@tiptap/extension-bullet-list` | `itemTypeName` |
| OrderedList | `@tiptap/extension-ordered-list` | `itemTypeName` |
| ListItem | `@tiptap/extension-list-item` | — |
| TaskList | `@tiptap/extension-task-list` | `itemTypeName` |
| TaskItem | `@tiptap/extension-task-item` | `nested`, `checked` attribute |
| Table | `@tiptap/extension-table` | `resizable`, `allowTableNodeSelection` |
| TableRow | `@tiptap/extension-table-row` | — |
| TableCell | `@tiptap/extension-table-cell` | — |
| TableHeader | `@tiptap/extension-table-header` | — |
| Image | `@tiptap/extension-image` | `inline`, `allowBase64` |
| Mention | `@tiptap/extension-mention` | `suggestion` config |
| Details | `@tiptap/extension-details` | — |
| DetailsContent | `@tiptap/extension-details-content` | — |
| DetailsSummary | `@tiptap/extension-details-summary` | — |
| Emoji | `@tiptap/extension-emoji` | — |
| Youtube | `@tiptap/extension-youtube` | — |
| Audio | `@tiptap/extension-audio` | — |
| Mathematics | `@tiptap/extension-mathematics` | — |

### Marks (provided by @tiptap/*)

| Extension | Package | Key options |
|-----------|---------|-------------|
| Bold | `@tiptap/extension-bold` | — |
| Italic | `@tiptap/extension-italic` | — |
| Strike | `@tiptap/extension-strike` | — |
| Code | `@tiptap/extension-code` | — |
| Link | `@tiptap/extension-link` | `autolink`, `openOnClick`, `linkOnPaste`, `HTMLAttributes` |
| Highlight | `@tiptap/extension-highlight` | `multicolor` |
| Underline | `@tiptap/extension-underline` | — |
| Subscript | `@tiptap/extension-subscript` | — |
| Superscript | `@tiptap/extension-superscript` | — |
| TextStyle | `@tiptap/extension-text-style` | Required for font family/size, color |

### Functionality (provided by @tiptap/*)

| Extension | Package | Description |
|-----------|---------|-------------|
| History | `@tiptap/extension-history` | `depth`, `newGroupDelay` |
| Gapcursor | `@tiptap/extension-gapcursor` | — |
| Dropcursor | `@tiptap/extension-dropcursor` | `color`, `width`, `class` |
| BubbleMenu | `@tiptap/extension-bubble-menu` | Selection-based popup |
| FloatingMenu | `@tiptap/extension-floating-menu` | Position-based popup |
| Placeholder | `@tiptap/extension-placeholder` | `placeholder`, `showOnlyWhenEditable`, `showOnlyCurrent` |
| Focus | `@tiptap/extension-focus` | `className` |
| TextAlign | `@tiptap/extension-text-align` | `types`, `alignments` |
| Color | `@tiptap/extension-color` | — |
| Highlight | `@tiptap/extension-highlight` | — |
| FontFamily | `@tiptap/extension-font-family` | — |
| FontSize | `@tiptap/extension-font-size` | — |
| LineHeight | `@tiptap/extension-line-height` | — |
| Typography | `@tiptap/extension-typography` | Smart quotes, em-dash, ellipsis |
| CharacterCount | `@tiptap/extension-character-count` | `limit`, `mode` |
| Collaboration | `@tiptap/extension-collaboration` | For use with Hocuspocus |
| CollaborationCaret | `@tiptap/extension-collaboration-caret` | — |
| UniqueID | `@tiptap/extension-unique-id` | — |
| TrailingNode | `@tiptap/extension-trailing-node` | `node` type |
| Selection | `@tiptap/extension-selection` | — |
| FileHandler | `@tiptap/extension-file-handler` | — |
| TableOfContents | `@tiptap/extension-table-of-contents` | — |
| ListKeymap | `@tiptap/extension-list-keymap` | — |
| ListKit | `@tiptap/extension-list-kit` | Bundle of list extensions |

## Pitfalls & gotchas

- **Chain requires `.run()`**: `editor.chain().toggleBold().toggleItalic()` does nothing without `.run()` at the end.
- **`can()` returns boolean**: Use `editor.can().chain().toggleBold().run()` (not `.can().toggleBold()` alone) to check a full chain.
- **Storage is namespaced**: `editor.storage.myExtensionName`, not `editor.storage.myOption`. Named by the extension's `name` field.
- **Node views vs `renderHTML`**: Node views are for in-editor rendering only. `renderHTML` controls the HTML output (copy/paste, getHTML). They can be completely different.
- **`contentDOM` is required for editable content**: If your node view should have editable text, you must provide a `contentDOM` element.
- **Extension order matters**: The order in the `extensions` array (and priority) determines plugin order and schema order. Higher priority = loaded earlier.
- **React node views require `@tiptap/react`**: You must use `ReactNodeViewRenderer` from `@tiptap/react`, not `@tiptap/core`.
- **`useEditor` is a hook**: In React, `useEditor` handles lifecycle (create on mount, destroy on unmount). Do not call `new Editor()` inside a React component.
- **`extends` vs `configure`**: Use `Extension.extend({...})` to create a modified copy of an extension. Use `Extension.configure({...})` to set options without copying.
- **`editor.chain()` inside commands**: Use the `chain` parameter, not `editor.chain()`, to chain inside custom commands:

```typescript
// Correct:
addCommands() {
  return {
    myCommand: () => ({ chain }) => chain().insertContent('foo').run(),
  }
}
// Wrong:
addCommands() {
  return {
    myCommand: () => () => editor.chain().insertContent('foo').run(),
  }
}
```

- **InputRule regex must end with `$`**: The `$` anchors the match to the cursor position. Paste rules instead use the `g` flag for global matching.
- **`nodeInputRule` vs `markInputRule`**: Use `nodeInputRule` for block nodes (images, horiz rules), `markInputRule` for inline marks (strike, code).
- **`editor.isEmpty` can be misleading**: It checks if the document is the default empty document. After `setContent('')`, the document might still contain an empty paragraph.
- **CSS must be loaded**: Tiptap injects basic CSS by default (`injectCSS: true`). For custom styling, target `.ProseMirror` and node-specific classes.
- **`onUpdate` fires often**: It fires on every content change. Use `onTransaction` if you need finer-grained control, or debounce `onUpdate` for expensive operations.
- **Transaction mapping with chains**: Since chained commands share one transaction, use `tr.mapping.map(pos)` inside commands to track positions across steps.

## Reference

- [Tiptap Documentation](https://tiptap.dev/docs/editor/getting-started/overview)
- [Tiptap Extension Docs](https://tiptap.dev/docs/editor/extensions/overview)
- [Tiptap API Reference](https://tiptap.dev/docs/editor/api/editor)
- [Tiptap Examples](https://tiptap.dev/docs/examples)
- [ProseMirror Reference Manual](https://prosemirror.net/docs/ref/) — For the underlying PM API
- [Tiptap GitHub](https://github.com/ueberdosis/tiptap)
- [Awesome Tiptap](https://github.com/ueberdosis/awesome-tiptap#community-extensions) — Community extensions
