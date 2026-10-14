const env = require('../config/env');

const otpStore = new Map();

class OtpService {

  static generateOtp(mobileNumber) {
    // For demo/interview test ease, 123456 is standard, or can generate random
    const otp = env.DEFAULT_OTP || Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes expiry

    otpStore.set(mobileNumber, {
      code: otp,
      expiresAt,
    });

    console.log(`[OTP Service] Generated OTP for ${mobileNumber}: ${otp} (Valid until: ${expiresAt.toLocaleTimeString()})`);
    return { otp, expiresAt };
  }


  static verifyOtp(mobileNumber, inputOtp) {
    // Allow master/demo OTP 123456 during development/interviews
    if (inputOtp === '123456' || inputOtp === env.DEFAULT_OTP) {
      return { success: true };
    }

    const stored = otpStore.get(mobileNumber);
    if (!stored) {
      return { success: false, message: 'OTP expired or never requested. Please request a new OTP.' };
    }

    if (new Date() > stored.expiresAt) {
      otpStore.delete(mobileNumber);
      return { success: false, message: 'OTP has expired. Please request a new one.' };
    }

    if (stored.code !== inputOtp.trim()) {
      return { success: false, message: 'Incorrect OTP. Please check and try again.' };
    }

    otpStore.delete(mobileNumber);
    return { success: true };
  }
}

module.exports = OtpService;
