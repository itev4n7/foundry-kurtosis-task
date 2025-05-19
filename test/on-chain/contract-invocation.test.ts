import { ethers } from 'ethers';
import crypto from 'crypto';
import { BROADCAST_CONTRACT_FILE_PATH, CONTRACT_ABI, CONTRAC_NAME } from '../../common/constants';
import { getContractAddress } from '../../common/deploy-info-util';

const RPC_URL = process.env.RPC_URL!;
const PRIVATE_KEY = process.env.PRIVATE_KEY!;

describe('Precompile wrapper contract on-chain tests', () => {
  const contractAddress = getContractAddress(BROADCAST_CONTRACT_FILE_PATH, CONTRAC_NAME);
  let provider: ethers.JsonRpcProvider;
  let wallet: ethers.Wallet;
  let contract: ethers.Contract;

  beforeAll(() => {
    provider = new ethers.JsonRpcProvider(RPC_URL);
    wallet = new ethers.Wallet(PRIVATE_KEY, provider);
    contract = new ethers.Contract(contractAddress, CONTRACT_ABI, wallet);
  });

  test('hashNumber updates hashedValue correctly', async () => {
    const numberToHash = 55;
    const buffer = Buffer.alloc(32);
    buffer.writeUInt8(numberToHash, 31);
    const expectedHash = '0x' + crypto.createHash('sha256').update(buffer).digest('hex');
    const tx = await contract.hashNumber(numberToHash);
    await tx.wait();
    const hashedValue = await contract.hashedValue();
    expect(hashedValue).toBe(expectedHash);
  }, 15000);
});
