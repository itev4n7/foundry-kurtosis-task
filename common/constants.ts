export enum PRECOMPILED_CONTRACTS {
  ecRecover = '0x0000000000000000000000000000000000000001',
  sha256 = '0x0000000000000000000000000000000000000002',
}

export enum RPC_METHODS {
  ethCall = 'eth_call',
  ethGetCode = 'eth_getCode',
  ethGetTransactionReceipt = 'eth_getTransactionReceipt',
}

export const CONTRACT_ABI = [
  {
    type: 'function',
    name: 'hashNumber',
    inputs: [{ name: 'number', type: 'uint256', internalType: 'uint256' }],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'hashedValue',
    inputs: [],
    outputs: [{ name: '', type: 'bytes32', internalType: 'bytes32' }],
    stateMutability: 'view',
  },
] as const;

export const BROADCAST_CONTRACT_FILE_PATH = 'broadcast/StorageHash.s.sol/10101/run-latest.json' as const;
export const CONTRAC_NAME = 'StorageHash' as const;
