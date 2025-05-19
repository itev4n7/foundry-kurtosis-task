import { BROADCAST_CONTRACT_FILE_PATH, RPC_METHODS, CONTRAC_NAME } from '../../common/constants';
import { jsonRpcCall } from '../../common/api-utils';
import { getContractAddress, getTransactionHash } from '../../common/deploy-info-util';
import { TransactionReceiptSchema } from '../../fixtures/schemas/transactionReceipt.schema';

describe('Post deploy RPC API tests', () => {
  test('retrieve Transaction Receipt', async () => {
    const txHash = getTransactionHash(BROADCAST_CONTRACT_FILE_PATH, CONTRAC_NAME);
    const receipt = await jsonRpcCall(RPC_METHODS.ethGetTransactionReceipt, [txHash]);
    expect(receipt).toBeDefined();
    expect(receipt.status).toBe('0x1');
    const parseResult = TransactionReceiptSchema.safeParse(receipt);
    expect(parseResult.success).toBeTruthy();
  });

  test('retrieve Contract Code', async () => {
    const contractAddress = getContractAddress(BROADCAST_CONTRACT_FILE_PATH, CONTRAC_NAME);
    const code = await jsonRpcCall(RPC_METHODS.ethGetCode, [contractAddress, 'latest']);
    expect(code).not.toBe('0x');
  });
});
