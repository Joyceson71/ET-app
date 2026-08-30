import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.hackpath.app',
  appName: 'HackPath',
  webDir: 'public',
  server: {
    url: 'http://10.0.2.2:3000', // Uses local dev server (Android emulator alias for localhost)
    cleartext: true
  }
};

export default config;
