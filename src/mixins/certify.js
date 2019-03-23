const signingService = window.connex.vendor.sign('cert');

const certify = {
  methods: {
    certify(content) {
      return signingService.request({
        purpose: 'identification',
        payload: {
          type: 'text',
          content,
        }
      });
    }
  }
};

export default certify;
