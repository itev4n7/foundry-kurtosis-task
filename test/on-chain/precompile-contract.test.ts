import { ethers } from 'ethers';
import crypto from 'crypto';
import { PRECOMPILED_CONTRACTS } from '../../common/constants';

const RPC_URL = process.env.RPC_URL!;

describe('Precompile contract on-chain tests', () => {
  let provider: ethers.JsonRpcProvider;

  beforeAll(() => {
    provider = new ethers.JsonRpcProvider(RPC_URL);
  });

  test('0x02 precompile SHA256 function', async () => {
    const inputString = 'Hello, Erigon!';
    const inputHex = '0x' + Buffer.from(inputString, 'utf8').toString('hex');
    const result = await provider.call({
      to: PRECOMPILED_CONTRACTS.sha256,
      data: inputHex,
    });
    const expectedHash = '0x' + crypto.createHash('sha256').update(inputString).digest('hex');
    expect(result).toBe(expectedHash);
  }, 15000);
});
