import { defineConfig } from "vitepress";

export default defineConfig({
  title: "AI Dotfiles",
  description:
    "Personal AI tooling configurations for opencode, Claude, and Codex",
  base: "/ai-dotfiles/",
  cleanUrls: true,

  head: [["link", { rel: "icon", type: "image/png", href: "/favicon.png" }]],

  themeConfig: {
    nav: [
      { text: "Guide", link: "/guide/", activeMatch: "/guide/" },
      { text: "Agents", link: "/agents/", activeMatch: "/agents/" },
      { text: "Skills", link: "/skills/", activeMatch: "/skills/" },
      {
        text: "Configuration",
        link: "/config/opencode",
        activeMatch: "/config/",
      },
      { text: "Installation", link: "/install/", activeMatch: "/install/" },
    ],

    sidebar: {
      "/guide/": [
        {
          text: "Guide",
          items: [
            { text: "Overview", link: "/guide/" },
            { text: "Getting Started", link: "/guide/getting-started" },
            { text: "Agent Workflow", link: "/guide/agent-workflow" },
            { text: "What Are Agents", link: "/guide/what-are-agents" },
          ],
        },
      ],
      "/agents/": [
        {
          text: "Agents",
          items: [
            { text: "Overview", link: "/agents/" },
            {
              text: "Architecture Planner",
              link: "/agents/architecture-planner",
            },
            { text: "Browser Tester", link: "/agents/browser-tester" },
            { text: "Code Reviewer", link: "/agents/code-reviewer" },
            { text: "Codebase Explorer", link: "/agents/codebase-explorer" },
            {
              text: "Dependency Upgrade Scout",
              link: "/agents/dependency-upgrade-scout",
            },
            { text: "Design Reviewer", link: "/agents/design-reviewer" },
            {
              text: "Design Polish Reviewer",
              link: "/agents/design-polish-reviewer",
            },
            {
              text: "Documentation Writer",
              link: "/agents/documentation-writer",
            },
            { text: "Idea Finder", link: "/agents/idea-finder" },
            { text: "Issue Triage Agent", link: "/agents/issue-triage-agent" },
            { text: "Peer Programmer", link: "/agents/peer-programmer" },
            {
              text: "Performance Investigator",
              link: "/agents/performance-investigator",
            },
            { text: "Regression Hunter", link: "/agents/regression-hunter" },
            { text: "Security Reviewer", link: "/agents/security-reviewer" },
            { text: "Test Strategist", link: "/agents/test-strategist" },
            {
              text: "TypeScript Type Reviewer",
              link: "/agents/typescript-type-reviewer",
            },
            { text: "API DX Reviewer", link: "/agents/api-dx-reviewer" },
            {
              text: "Accessibility Auditor",
              link: "/agents/accessibility-auditor",
            },
          ],
        },
      ],
      "/skills/": [
        {
          text: "Skills",
          items: [
            { text: "Overview", link: "/skills/" },
            {
              text: "Accessibility Review",
              link: "/skills/accessibility-review",
            },
            { text: "Browser Debug", link: "/skills/browser-debug" },
            {
              text: "Browser Design Review",
              link: "/skills/browser-design-review",
            },
            { text: "Browser Test", link: "/skills/browser-test" },
            { text: "Code Review", link: "/skills/code-review" },
          ],
        },
      ],
      "/config/": [
        {
          text: "Configuration",
          items: [
            { text: "Opencode", link: "/config/opencode" },
            { text: "Claude", link: "/config/claude" },
            { text: "Codex", link: "/config/codex" },
          ],
        },
      ],
      "/install/": [
        {
          text: "Installation",
          items: [
            { text: "Overview", link: "/install/" },
            { text: "UNIX (Linux / macOS)", link: "/install/unix" },
            { text: "Windows", link: "/install/windows" },
          ],
        },
      ],
    },

    socialLinks: [
      { icon: "github", link: "https://github.com/bdbch/ai-dotfiles" },
    ],

    footer: {
      message: "Built with VitePress",
      copyright: "MIT License",
    },
  },
});
