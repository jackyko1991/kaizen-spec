import { defineConfig } from 'vitepress'

// Sidebar structure shared across all locales (paths are locale-relative).
// VitePress prepends the locale root automatically, so /guide/ resolves to
// /zh-TW/guide/ when rendered in the zh-TW locale.
const guideSidebar = (items: { text: string; link: string }[]) => [
  { text: items[0].text, items }
]

export default defineConfig({
  title: 'kaizen-spec',
  description: 'Spec-driven, kaizen-informed agentic development for Claude Code',
  base: '/kaizen-spec/',
  appearance: 'auto',
  head: [['link', { rel: 'icon', href: '/kaizen-spec/favicon.svg' }]],

  locales: {
    root: {
      label: 'English',
      lang: 'en-US',
      themeConfig: {
        nav: [
          { text: 'Guide', link: '/guide/getting-started' },
          { text: 'Reference', link: '/reference/state-schema' },
        ],
        sidebar: {
          '/guide/': [{ text: 'Guide', items: [
            { text: 'Getting Started',        link: '/guide/getting-started' },
            { text: 'Philosophy',             link: '/guide/philosophy' },
            { text: 'Glossary',               link: '/guide/glossary' },
            { text: 'The Five Phases',        link: '/guide/phases' },
            { text: 'Kanban Board',           link: '/guide/kanban' },
          ]}],
          '/reference/': [{ text: 'Reference', items: [
            { text: 'Kaizen & Kanban Terminology', link: '/reference/kaizen-glossary' },
            { text: 'State Schema',               link: '/reference/state-schema' },
            { text: 'Kaizen Log Format',          link: '/reference/kaizen-log' },
          ]}],
        },
      },
    },

    'zh-TW': {
      label: '繁體中文',
      lang: 'zh-TW',
      // All paths are absolute - VitePress does NOT auto-prepend locale prefix
      // for nav links, sidebar keys, or sidebar item links.
      themeConfig: {
        nav: [
          { text: '指南', link: '/zh-TW/guide/getting-started' },
          { text: '參考', link: '/zh-TW/reference/state-schema' },
        ],
        sidebar: {
          '/zh-TW/guide/': [{ text: '指南', items: [
            { text: '快速入門',   link: '/zh-TW/guide/getting-started' },
            { text: '理念哲學',   link: '/zh-TW/guide/philosophy' },
            { text: '術語表',     link: '/zh-TW/guide/glossary' },
            { text: '五個階段',   link: '/zh-TW/guide/phases' },
            { text: '生產看板',   link: '/zh-TW/guide/kanban' },
          ]}],
          '/zh-TW/reference/': [{ text: '參考', items: [
            { text: '改善與看板術語', link: '/zh-TW/reference/kaizen-glossary' },
            { text: '狀態結構',       link: '/zh-TW/reference/state-schema' },
            { text: '改善日誌格式',   link: '/zh-TW/reference/kaizen-log' },
          ]}],
        },
      },
    },

    'ja': {
      label: '日本語',
      lang: 'ja-JP',
      // All paths are absolute - VitePress does NOT auto-prepend locale prefix.
      themeConfig: {
        nav: [
          { text: 'ガイド',         link: '/ja/guide/getting-started' },
          { text: 'リファレンス',   link: '/ja/reference/state-schema' },
        ],
        sidebar: {
          '/ja/guide/': [{ text: 'ガイド', items: [
            { text: 'はじめに',           link: '/ja/guide/getting-started' },
            { text: '哲学・理念',         link: '/ja/guide/philosophy' },
            { text: '用語集',             link: '/ja/guide/glossary' },
            { text: '5つのフェーズ',      link: '/ja/guide/phases' },
            { text: 'かんばんボード',     link: '/ja/guide/kanban' },
          ]}],
          '/ja/reference/': [{ text: 'リファレンス', items: [
            { text: '改善・かんばん用語',   link: '/ja/reference/kaizen-glossary' },
            { text: 'ステートスキーマ',     link: '/ja/reference/state-schema' },
            { text: '改善ログ形式',         link: '/ja/reference/kaizen-log' },
          ]}],
        },
      },
    },
  },

  themeConfig: {
    logo: '/favicon.svg',
    socialLinks: [
      { icon: 'github', link: 'https://github.com/jackyko1991/kaizen-spec' },
    ],
    footer: {
      message: 'Released under the MIT License.',
      copyright: 'Built with kaizen-spec',
    },
    search: {
      provider: 'local',
    },
  },
})
