import { hexToBytes } from 'web3-utils';

const network = {
  methods: {
    async getNetwork() {
      const block = await window.connex.thor.block(0).get();
      return hexToBytes(block.id).pop();
    }
  }
};

export default network;
