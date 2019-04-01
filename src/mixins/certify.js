const certify = {
  methods: {
    certify(content) {
      const signingService = window.connex.vendor.sign('cert');

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
