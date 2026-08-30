import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: "class",
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        background: "#0D0F14",
        surface: "#141720",
        "surface-2": "#1A1F2E",
        border: "#1F2330",
        "accent-primary": "#00FF9C",
        "accent-secondary": "#7B61FF",
        warning: "#FF6B35",
        "text-primary": "#E8EAF0",
        "text-muted": "#5A6070",
        // Semantic aliases
        primary: {
          DEFAULT: "#00FF9C",
          foreground: "#0D0F14",
        },
        secondary: {
          DEFAULT: "#7B61FF",
          foreground: "#E8EAF0",
        },
        destructive: {
          DEFAULT: "#FF3B3B",
          foreground: "#E8EAF0",
        },
        muted: {
          DEFAULT: "#1A1F2E",
          foreground: "#5A6070",
        },
        accent: {
          DEFAULT: "#1F2330",
          foreground: "#E8EAF0",
        },
        popover: {
          DEFAULT: "#141720",
          foreground: "#E8EAF0",
        },
        card: {
          DEFAULT: "#141720",
          foreground: "#E8EAF0",
        },
        input: "#1F2330",
        ring: "#00FF9C",
        foreground: "#E8EAF0",
      },
      fontFamily: {
        mono: ["JetBrains Mono", "Fira Code", "monospace"],
        sans: ["Inter", "system-ui", "sans-serif"],
        code: ["Fira Code", "monospace"],
      },
      borderRadius: {
        lg: "0.75rem",
        md: "0.5rem",
        sm: "0.375rem",
      },
      keyframes: {
        "typewriter": {
          "0%": { width: "0" },
          "100%": { width: "100%" },
        },
        "blink-cursor": {
          "0%, 100%": { opacity: "1" },
          "50%": { opacity: "0" },
        },
        "scanner-fill": {
          "0%": { backgroundPosition: "-200% 0" },
          "100%": { backgroundPosition: "200% 0" },
        },
        "pulse-glow": {
          "0%, 100%": { boxShadow: "0 0 4px #00FF9C, 0 0 8px #00FF9C40" },
          "50%": { boxShadow: "0 0 12px #00FF9C, 0 0 24px #00FF9C60" },
        },
        "fade-in-up": {
          "0%": { opacity: "0", transform: "translateY(16px)" },
          "100%": { opacity: "1", transform: "translateY(0)" },
        },
        "slide-in-right": {
          "0%": { opacity: "0", transform: "translateX(16px)" },
          "100%": { opacity: "1", transform: "translateX(0)" },
        },
        "node-pulse": {
          "0%, 100%": { transform: "scale(1)", opacity: "0.8" },
          "50%": { transform: "scale(1.08)", opacity: "1" },
        },
        "spin-slow": {
          "0%": { transform: "rotate(0deg)" },
          "100%": { transform: "rotate(360deg)" },
        },
        "shimmer": {
          "0%": { backgroundPosition: "-1000px 0" },
          "100%": { backgroundPosition: "1000px 0" },
        },
      },
      animation: {
        "typewriter": "typewriter 2s steps(40) forwards",
        "blink-cursor": "blink-cursor 1s step-end infinite",
        "scanner-fill": "scanner-fill 2s linear infinite",
        "pulse-glow": "pulse-glow 2s ease-in-out infinite",
        "fade-in-up": "fade-in-up 0.5s ease-out",
        "slide-in-right": "slide-in-right 0.3s ease-out",
        "node-pulse": "node-pulse 2s ease-in-out infinite",
        "spin-slow": "spin-slow 8s linear infinite",
        "shimmer": "shimmer 2s infinite linear",
      },
      backgroundImage: {
        "gradient-radial": "radial-gradient(var(--tw-gradient-stops))",
        "gradient-conic": "conic-gradient(from 180deg at 50% 50%, var(--tw-gradient-stops))",
        "terminal-grid": "linear-gradient(#1F233020 1px, transparent 1px), linear-gradient(90deg, #1F233020 1px, transparent 1px)",
        "glow-green": "radial-gradient(ellipse at center, #00FF9C20 0%, transparent 70%)",
        "glow-violet": "radial-gradient(ellipse at center, #7B61FF20 0%, transparent 70%)",
      },
      backgroundSize: {
        "terminal-grid": "24px 24px",
      },
      boxShadow: {
        "glow-green": "0 0 8px #00FF9C60, 0 0 20px #00FF9C30",
        "glow-violet": "0 0 8px #7B61FF60, 0 0 20px #7B61FF30",
        "glow-orange": "0 0 8px #FF6B3560, 0 0 20px #FF6B3530",
        "card": "0 1px 3px rgba(0,0,0,0.4), 0 1px 2px rgba(0,0,0,0.3)",
        "card-hover": "0 4px 16px rgba(0,0,0,0.4), 0 0 0 1px #00FF9C20",
      },
    },
  },
  plugins: [],
};

export default config;
