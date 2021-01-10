Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,
           Rails.application.credentials.facebook[:app_id],
           Rails.application.credentials.facebook[:app_secret],
           scope: 'email',
           display: 'popup',
           local: 'ja_JP',
           info_fields: "email, id, name"

  provider :linkedin,
           Rails.application.credentials.linkedin[:app_id],
           Rails.application.credentials.linkedin[:app_secret],
           scope: 'r_liteprofile r_emailaddress',
           fields: ['email-address', 'id', 'first-name', 'last-name']
end
