import axios from 'axios';

export async function jsonRpcCall(method: string, params: any[]) {
    const response = await axios.post(process.env.RPC_URL!, {
      jsonrpc: '2.0',
      id: 1,
      method,
      params,
    });
    return response.data.result;
  }