export class UserEntity {
  id: string;
  name: string;
  phone: string | null;
  countryCode: string | null;
  email: string;
  passwordHash: string | null;
  gender: 'MALE' | 'FEMALE' | null;
  dob: string | null; // format: YYYY-MM-DD
  avatarUrl: string | null;
  offersEnabled: boolean;
  isProfileComplete: boolean;
  socialProvider: 'google' | 'facebook' | null;
  socialToken: string | null;

  constructor(partial: Partial<UserEntity>) {
    Object.assign(this, partial);
    this.offersEnabled = partial.offersEnabled ?? false;
    this.isProfileComplete = partial.isProfileComplete ?? false;
    this.socialProvider = partial.socialProvider ?? null;
    this.socialToken = partial.socialToken ?? null;
  }

  completeProfile(data: { gender: 'MALE' | 'FEMALE'; dob: string; offersEnabled: boolean; avatarUrl?: string }): void {
    this.gender = data.gender;
    this.dob = data.dob;
    this.offersEnabled = data.offersEnabled;
    if (data.avatarUrl) {
      this.avatarUrl = data.avatarUrl;
    }
    this.isProfileComplete = true;
  }
}
