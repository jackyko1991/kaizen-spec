import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'kaizen-spec',
  description: 'Spec-driven, kaizen-informed agentic development for Claude Code',
  appearance: 'auto',
  head: [['link', { rel: 'icon', href: '/favicon.svg' }]],

  themeConfig: {
    nav: [
      { text: 'Guide', link: '/guide/getting-started' },
      { text: 'Reference', link: '/reference/state-schema' },
    ],

    sidebar: {
      '/guide/': [
        {
          text: 'Guide',
          items: [
            { text: 'Getting Started', link: '/guide/getting-started' },
            { text: 'The Five Phases', link: '/guide/phases' },
            { text: 'Kanban Board', link: '/guide/kanban' },
          ],
        },
      ],
      '/reference/': [
        {
          text: 'Reference',
          items: [
            { text: 'Kaizen & Kanban Terminology', link: '/reference/kaizen-glossary' },
            { text: 'State Schema', link: '/reference/state-schema' },
            { text: 'Kaizen Log Format', link: '/reference/kaizen-log' },
          ],
        },
      ],
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/jackyko/kaizen-spec' },
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
