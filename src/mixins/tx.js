const signingService = window.connex.vendor.sign('tx');

const tx = {
  methods: {
    tx({ comment, signer, clause }) {
      return signingService
        .signer(signer)
        .link('https://connex.vecha.in/{txid')
        .comment(comment)
        .request([ clause ]);
    }
  }
};

export default tx;
