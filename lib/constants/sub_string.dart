facebookSiteLink(String sendFbLink) {
  if (sendFbLink.endsWith('/')) {
    sendFbLink = sendFbLink.substring(0, sendFbLink.length - 1);
    return sendFbLink.split('.com/').last;
  } else {
    return sendFbLink.split('.com/').last;
  }
}

instagramSiteLink(String sendInLink) {
  if (sendInLink.endsWith('/')) {
    sendInLink = sendInLink.substring(0, sendInLink.length - 1);
    return sendInLink.split('.com/').last;
  } else {
    return sendInLink.split('.com/').last;
  }
}
