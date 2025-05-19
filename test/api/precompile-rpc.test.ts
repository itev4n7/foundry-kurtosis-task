import crypto from 'crypto';
import { PRECOMPILED_CONTRACTS, RPC_METHODS } from '../../common/constants';
import { jsonRpcCall } from '../../common/api-utils';

describe('Precompile contract RPC API tests', () => {
  test('0x02 precompile SHA256 function', async () => {
    const inputString = 'Hello, Erigon!';
    const inputHex = '0x' + Buffer.from(inputString, 'utf8').toString('hex');
    const params = {
      to: PRECOMPILED_CONTRACTS.sha256,
      data: inputHex,
    };
    const result = await jsonRpcCall(RPC_METHODS.ethCall, [params, 'latest']);
    const expectedHash = '0x' + crypto.createHash('sha256').update(inputString).digest('hex');
    expect(result).toBe(expectedHash);
  }, 15000);
});