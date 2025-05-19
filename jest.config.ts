export default {
    preset: 'ts-jest',
    testEnvironment: 'node',
    setupFiles: ['./jest.setup.ts'],
    testMatch: ['<rootDir>/test/**/*.test.ts'],
  };