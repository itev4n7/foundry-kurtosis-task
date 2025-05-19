import fs from 'fs';
import path from 'path';

function readJsonFile(filePath: string) {
  const absolutePath = path.resolve(filePath);
  const rawData = fs.readFileSync(absolutePath, 'utf-8');
  const json = JSON.parse(rawData);
  if (!Array.isArray(json.transactions)) {
    throw new Error("Invalid JSON: 'transactions' key missing or not an array");
  }
  return json;
}

function getTransactionWithContractName(json: any, contractName: string) {
  const tx = json.transactions.find(
    (data: any) => data.contractName === contractName && data.transactionType === 'CREATE',
  );
  if (!tx) {
    console.warn(`Contract ${contractName} not found in deployment transactions`);
    return null;
  }
  return tx;
}

export function getContractAddress(jsonFilePath: string, contractName: string) {
  try {
    const json = readJsonFile(jsonFilePath);
    const tx = getTransactionWithContractName(json, contractName);
    return tx.contractAddress;
  } catch (err) {
    console.error('Error reading contract address info:', err);
    return null;
  }
}

export function getTransactionHash(jsonFilePath: string, contractName: string) {
  try {
    const json = readJsonFile(jsonFilePath);
    const tx = getTransactionWithContractName(json, contractName);
    return tx.hash;
  } catch (err) {
    console.error('Error reading transaction hash info:', err);
    return null;
  }
}
