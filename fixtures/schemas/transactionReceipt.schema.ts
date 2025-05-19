import { z } from 'zod';

export const TransactionReceiptSchema = z.object({
  blockHash: z.string(),
  blockNumber: z.string(),
  contractAddress: z.string().nullable(),
  cumulativeGasUsed: z.string(),
  effectiveGasPrice: z.string(),
  from: z.string(),
  gasUsed: z.string(),
  logs: z.array(z.any()),
  logsBloom: z.string(),
  status: z.string(),
  to: z.string().nullable(),
  transactionHash: z.string(),
  transactionIndex: z.string(),
  type: z.string(),
});

export type TransactionReceipt = z.infer<typeof TransactionReceiptSchema>;
