import 'dart:async';

import 'package:func/func.dart';
import 'package:js/js.dart';

import 'app.dart';
import 'interop/auth_interop.dart';
import 'interop/firebase_interop.dart' as firebase_interop;
import 'js.dart';
import 'utils.dart';

export 'interop/auth_interop.dart'
    show ActionCodeInfo, ActionCodeEmail, AuthCredential;
export 'interop/firebase_interop.dart' show UserProfile;

/// User profile information, visible only to the Firebase project's apps.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.UserInfo>.
class UserInfo<T extends firebase_interop.UserInfoJsImpl>
    extends JsObjectWrapper<T> {
  /// User's display name.
  String get displayName => jsObject.displayName;

  /// User's e-mail address.
  String get email => jsObject.email;

  /// The user's E.164 formatted phone number (if available).
  String get phoneNumber => jsObject.phoneNumber;

  /// User's profile picture URL.
  String get photoURL => jsObject.photoURL;

  /// User's authentication provider ID.
  String get providerId => jsObject.providerId;

  /// User's unique ID.
  String get uid => jsObject.uid;

  /// Creates a new UserInfo from a [jsObject].
  UserInfo.fromJsObject(T jsObject) : super.fromJsObject(jsObject);
}

/// User account.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.User>.
class User extends UserInfo<firebase_interop.UserJsImpl> {
  static final _expando = new Expando<User>();

  /// If the user's email address has been already verified.
  bool get emailVerified => jsObject.emailVerified;

  /// If the user is anonymous.
  bool get isAnonymous => jsObject.isAnonymous;

  /// List of additional provider-specific information about the user.
  List<UserInfo> get providerData => jsObject.providerData
      .map((data) =>
          new UserInfo<firebase_interop.UserInfoJsImpl>.fromJsObject(data))
      .toList();

  /// Refresh token for the user account.
  String get refreshToken => jsObject.refreshToken;

  /// Creates a new User from a [jsObject].
  ///
  /// If an instance of [User] is already associated with [jsObject], it is
  /// returned instead of creating a new instance.
  ///
  /// If [jsObject] is `null`, `null` is returned.
  static User get(firebase_interop.UserJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= new User._fromJsObject(jsObject);
  }

  User._fromJsObject(firebase_interop.UserJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Deletes and signs out the user.
  Future delete() => handleThenable(jsObject.delete());

  /// Returns a JWT token used to identify the user to a Firebase service.
  ///
  /// It forces refresh regardless of token expiration if [forceRefresh]
  /// parameter is [true].
  ///
  /// This method is **DEPRECATED**. Use [getIdToken] instead.
  @Deprecated('Use `getIdToken` instead.')
  Future<String> getToken([bool forceRefresh = false]) =>
      handleThenable(jsObject.getToken(forceRefresh));

  /// Returns a JWT token used to identify the user to a Firebase service.
  ///
  /// Returns the current token if it has not expired, otherwise this will
  /// refresh the token and return a new one.
  ///
  /// It forces refresh regardless of token expiration if [forceRefresh]
  /// parameter is [true].
  Future<String> getIdToken([bool forceRefresh = false]) =>
      handleThenable(jsObject.getIdToken(forceRefresh));

  /// Links the user account with the given credentials, and returns any
  /// available additional user information, such as user name.
  Future<UserCredential> linkAndRetrieveDataWithCredential(
          AuthCredential credential) =>
      handleThenableWithMapper(
          jsObject.linkAndRetrieveDataWithCredential(credential),
          (u) => new UserCredential.fromJsObject(u));

  /// Links the user account with the given [credential] and returns the user.
  Future<User> linkWithCredential(AuthCredential credential) =>
      handleThenableWithMapper(
          jsObject.linkWithCredential(credential), User.get);

  /// Links the user account with the given [phoneNumber] in E.164 format
  /// (e.g. +16505550101) and [applicationVerifier].
  Future<ConfirmationResult> linkWithPhoneNumber(
          String phoneNumber, ApplicationVerifier applicationVerifier) =>
      handleThenableWithMapper(
          jsObject.linkWithPhoneNumber(
              phoneNumber, applicationVerifier.jsObject),
          (c) => new ConfirmationResult.fromJsObject(c));

  /// Links the authenticated [provider] to the user account using
  /// a pop-up based OAuth flow.
  /// It returns the [UserCredential] information if linking is successful.
  Future<UserCredential> linkWithPopup(AuthProvider provider) =>
      handleThenableWithMapper(jsObject.linkWithPopup(provider.jsObject),
          (u) => new UserCredential.fromJsObject(u));

  /// Links the authenticated [provider] to the user account using
  /// a full-page redirect flow.
  Future linkWithRedirect(AuthProvider provider) =>
      handleThenable(jsObject.linkWithRedirect(provider.jsObject));

  // FYI: as of 2017-07-03 – the return type of this guy is documented as
  // Promise (Future)<nothing> - Filed a bug internally.
  /// Re-authenticates a user using a fresh credential, and returns any
  /// available additional user information, such as user name.
  Future<UserCredential> reauthenticateAndRetrieveDataWithCredential(
          AuthCredential credential) =>
      handleThenableWithMapper(
          jsObject.reauthenticateAndRetrieveDataWithCredential(credential),
          (o) => new UserCredential.fromJsObject(o));

  /// Re-authenticates a user using a fresh credential.
  /// Use before operations such as [updatePassword] that require tokens
  /// from recent sign-in attempts.
  ///
  /// The user's phone number is in E.164 format (e.g. +16505550101).
  Future<ConfirmationResult> reauthenticateWithPhoneNumber(
          String phoneNumber, ApplicationVerifier applicationVerifier) =>
      handleThenableWithMapper(
          jsObject.reauthenticateWithPhoneNumber(
              phoneNumber, applicationVerifier.jsObject),
          (c) => new ConfirmationResult.fromJsObject(c));

  /// Re-authenticates a user using a fresh [credential]. Should be used
  /// before operations such as [updatePassword()] that require tokens
  /// from recent sign in attempts.
  Future reauthenticateWithCredential(AuthCredential credential) =>
      handleThenable(jsObject.reauthenticateWithCredential(credential));

  /// Reauthenticates a user with the specified provider using
  /// a pop-up based OAuth flow.
  /// It returns the [UserCredential] information if reauthentication is successful.
  Future<UserCredential> reauthenticateWithPopup(AuthProvider provider) =>
      handleThenableWithMapper(
          jsObject.reauthenticateWithPopup(provider.jsObject),
          (u) => new UserCredential.fromJsObject(u));

  /// Reauthenticates a user with the specified OAuth [provider] using
  /// a full-page redirect flow.
  Future reauthenticateWithRedirect(AuthProvider provider) =>
      handleThenable(jsObject.reauthenticateWithRedirect(provider.jsObject));

  /// If signed in, it refreshes the current user.
  Future reload() => handleThenable(jsObject.reload());

  /// Sends an e-mail verification to a user.
  Future sendEmailVerification() =>
      handleThenable(jsObject.sendEmailVerification());

  /// Unlinks a provider with [providerId] from a user account.
  Future<User> unlink(String providerId) =>
      handleThenableWithMapper(jsObject.unlink(providerId), User.get);

  /// Updates the user's e-mail address to [newEmail].
  Future updateEmail(String newEmail) =>
      handleThenable(jsObject.updateEmail(newEmail));

  /// Updates the user's password to [newPassword].
  /// Requires the user to have recently signed in. If not, ask the user
  /// to authenticate again and then use [reauthenticate()].
  Future updatePassword(String newPassword) =>
      handleThenable(jsObject.updatePassword(newPassword));

  /// Updates the user's phone number.
  Future updatePhoneNumber(AuthCredential phoneCredential) =>
      handleThenable(jsObject.updatePhoneNumber(phoneCredential));

  /// Updates a user's [profile] data.
  /// UserProfile has a displayName and photoURL.
  ///
  ///     UserProfile profile = new UserProfile(displayName: "Smart user");
  ///     await user.updateProfile(profile);
  Future updateProfile(firebase_interop.UserProfile profile) =>
      handleThenable(jsObject.updateProfile(profile));

  /// Returns a JSON-serializable representation of this object.
  Map<String, dynamic> toJson() => dartify(jsObject.toJSON());

  @override
  String toString() => 'User: $uid';
}

/// The Firebase Auth service class.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.Auth>.
class Auth extends JsObjectWrapper<AuthJsImpl> {
  static final _expando = new Expando<Auth>();

  /// App for this instance of auth service.
  App get app => App.get(jsObject.app);

  /// Currently signed-in [User].
  User get currentUser => User.get(jsObject.currentUser);

  Func0 _onAuthUnsubscribe;
  StreamController<User> _changeController;

  /// Sends events when the users sign-in state changes.
  ///
  /// After 4.0.0, this is only triggered on sign-in or sign-out.
  /// To keep the old behavior, see [onIdTokenChanged].
  ///
  /// If the value is `null`, there is no signed-in user.
  Stream<User> get onAuthStateChanged {
    if (_changeController == null) {
      var nextWrapper = allowInterop((firebase_interop.UserJsImpl user) {
        _changeController.add(User.get(user));
      });

      var errorWrapper = allowInterop((e) => _changeController.addError(e));

      void startListen() {
        assert(_onAuthUnsubscribe == null);
        _onAuthUnsubscribe =
            jsObject.onAuthStateChanged(nextWrapper, errorWrapper);
      }

      void stopListen() {
        _onAuthUnsubscribe();
        _onAuthUnsubscribe = null;
      }

      _changeController = new StreamController<User>.broadcast(
          onListen: startListen, onCancel: stopListen, sync: true);
    }
    return _changeController.stream;
  }

  Func0 _onIdTokenChangedUnsubscribe;
  StreamController<User> _idTokenChangedController;

  /// Sends events for changes to the signed-in user's ID token,
  /// which includes sign-in, sign-out, and token refresh events.
  ///
  /// This method has the same behavior as [onAuthStateChanged] had prior to 4.0.0.
  ///
  /// If the value is `null`, there is no signed-in user.
  Stream<User> get onIdTokenChanged {
    if (_idTokenChangedController == null) {
      var nextWrapper = allowInterop((firebase_interop.UserJsImpl user) {
        _idTokenChangedController.add(User.get(user));
      });

      var errorWrapper =
          allowInterop((e) => _idTokenChangedController.addError(e));

      void startListen() {
        assert(_onIdTokenChangedUnsubscribe == null);
        _onIdTokenChangedUnsubscribe =
            jsObject.onIdTokenChanged(nextWrapper, errorWrapper);
      }

      void stopListen() {
        _onIdTokenChangedUnsubscribe();
        _onIdTokenChangedUnsubscribe = null;
      }

      _idTokenChangedController = new StreamController<User>.broadcast(
          onListen: startListen, onCancel: stopListen, sync: true);
    }
    return _idTokenChangedController.stream;
  }

  /// Creates a new Auth from a [jsObject].
  static Auth get(AuthJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= new Auth._fromJsObject(jsObject);
  }

  Auth._fromJsObject(AuthJsImpl jsObject) : super.fromJsObject(jsObject);

  /// Applies a verification [code] sent to the user by e-mail or by other
  /// out-of-band mechanism.
  Future applyActionCode(String code) =>
      handleThenable(jsObject.applyActionCode(code));

  /// Checks a verification [code] sent to the user by e-mail or by other
  /// out-of-band mechanism.
  /// It returns [ActionCodeInfo], metadata about the code.
  Future<ActionCodeInfo> checkActionCode(String code) =>
      handleThenable(jsObject.checkActionCode(code));

  /// Completes password reset process with a [code] and a [newPassword].
  Future confirmPasswordReset(String code, String newPassword) =>
      handleThenable(jsObject.confirmPasswordReset(code, newPassword));

  /// Creates a new user account with [email] and [password].
  /// After a successful creation, the user will be signed into application
  /// and the [User] object is returned.
  ///
  /// The creation can fail, if the user with given [email] already exists
  /// or the password is not valid.
  Future<User> createUserWithEmailAndPassword(String email, String password) =>
      handleThenableWithMapper(
          jsObject.createUserWithEmailAndPassword(email, password), User.get);

  /// Returns the list of provider IDs for the given [email] address,
  /// that can be used to sign in.
  Future<List<String>> fetchProvidersForEmail(String email) =>
      handleThenable(jsObject.fetchProvidersForEmail(email));

  /// Returns a [UserCredential] from the redirect-based sign in flow.
  /// If sign is successful, returns the signed in user. Or fails with an error
  /// if sign is unsuccessful.
  /// The [UserCredential] with a null [User] is returned if no redirect
  /// operation was called.
  Future<UserCredential> getRedirectResult() => handleThenableWithMapper(
      jsObject.getRedirectResult(), (u) => new UserCredential.fromJsObject(u));

  /// Sends a password reset e-mail to the given [email].
  /// To confirm password reset, use the [Auth.confirmPasswordReset].
  Future sendPasswordResetEmail(String email) =>
      handleThenable(jsObject.sendPasswordResetEmail(email));

  /// Asynchronously signs in with the given credentials, and returns any
  /// available additional user information, such as user name.
  Future<UserCredential> signInAndRetrieveDataWithCredential(
          AuthCredential credential) =>
      handleThenableWithMapper(
          jsObject.signInAndRetrieveDataWithCredential(credential),
          (uc) => new UserCredential.fromJsObject(uc));

  /// Signs in as an anonymous user. If an anonymous user is already
  /// signed in, that user will be returned. In other case, new anonymous
  /// [User] identity is created and returned.
  Future<User> signInAnonymously() =>
      handleThenableWithMapper(jsObject.signInAnonymously(), User.get);

  /// Signs in with the given [credential] and returns the [User].
  Future<User> signInWithCredential(AuthCredential credential) =>
      handleThenableWithMapper(
          jsObject.signInWithCredential(credential), User.get);

  /// Signs in with the custom [token] and returns the [User].
  /// Custom token must be generated by an auth backend.
  /// Fails with an error if the token is invalid, expired or not accepted
  /// by Firebase Auth service.
  Future<User> signInWithCustomToken(String token) =>
      handleThenableWithMapper(jsObject.signInWithCustomToken(token), User.get);

  /// Signs in with [email] and [password] and returns the [User].
  /// Fails with an error if the sign in is not successful.
  Future<User> signInWithEmailAndPassword(String email, String password) =>
      handleThenableWithMapper(
          jsObject.signInWithEmailAndPassword(email, password), User.get);

  /// Asynchronously signs in using a phone number in E.164 format
  /// (e.g. +16505550101).
  ///
  /// This method sends a code via SMS to the given phone number, and returns
  /// a [ConfirmationResult].
  /// After the user provides the code sent to their phone, call
  /// [ConfirmationResult.confirm] with the code to sign the user in.
  ///
  /// For abuse prevention, this method also requires a [ApplicationVerifier].
  /// The Firebase Auth SDK includes a reCAPTCHA-based implementation, [RecaptchaVerifier].
  Future<ConfirmationResult> signInWithPhoneNumber(
          String phoneNumber, ApplicationVerifier applicationVerifier) =>
      handleThenableWithMapper(
          jsObject.signInWithPhoneNumber(
              phoneNumber, applicationVerifier.jsObject),
          (c) => new ConfirmationResult.fromJsObject(c));

  /// Signs in using a popup-based OAuth authentication flow with the
  /// given [provider].
  /// Returns [UserCredential] if successful, or an error object if unsuccessful.
  Future<UserCredential> signInWithPopup(AuthProvider provider) =>
      handleThenableWithMapper(jsObject.signInWithPopup(provider.jsObject),
          (u) => new UserCredential.fromJsObject(u));

  /// Signs in using a full-page redirect flow with the given [provider].
  Future signInWithRedirect(AuthProvider provider) =>
      handleThenable(jsObject.signInWithRedirect(provider.jsObject));

  /// Signs out the current user.
  Future signOut() => handleThenable(jsObject.signOut());

  /// Verifies a password reset [code] sent to the user by email
  /// or other out-of-band mechanism.
  /// Returns the user's e-mail address if valid.
  Future<String> verifyPasswordResetCode(String code) =>
      handleThenable(jsObject.verifyPasswordResetCode(code));
}

/// Represents an auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.AuthProvider>.
abstract class AuthProvider<T extends AuthProviderJsImpl>
    extends JsObjectWrapper<T> {
  /// Provider id.
  String get providerId => jsObject.providerId;

  /// Creates a new AuthProvider from a [jsObject].
  AuthProvider.fromJsObject(T jsObject) : super.fromJsObject(jsObject);
}

/// E-mail and password auth provider implementation.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.EmailAuthProvider>.
class EmailAuthProvider extends AuthProvider<EmailAuthProviderJsImpl> {
  static String PROVIDER_ID = EmailAuthProviderJsImpl.PROVIDER_ID;

  /// Creates a new EmailAuthProvider.
  factory EmailAuthProvider() =>
      new EmailAuthProvider.fromJsObject(new EmailAuthProviderJsImpl());

  /// Creates a new EmailAuthProvider from a [jsObject].
  EmailAuthProvider.fromJsObject(EmailAuthProviderJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Creates a credential for e-mail.
  static AuthCredential credential(String email, String password) =>
      EmailAuthProviderJsImpl.credential(email, password);
}

/// Facebook auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.FacebookAuthProvider>.
class FacebookAuthProvider extends AuthProvider<FacebookAuthProviderJsImpl> {
  static String PROVIDER_ID = FacebookAuthProviderJsImpl.PROVIDER_ID;

  /// Creates a new FacebookAuthProvider.
  factory FacebookAuthProvider() =>
      new FacebookAuthProvider.fromJsObject(new FacebookAuthProviderJsImpl());

  /// Creates a new FacebookAuthProvider from a [jsObject].
  FacebookAuthProvider.fromJsObject(FacebookAuthProviderJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Adds additional OAuth 2.0 scopes that you want to request from the
  /// authentication provider.
  FacebookAuthProvider addScope(String scope) =>
      new FacebookAuthProvider.fromJsObject(jsObject.addScope(scope));

  /// Sets the OAuth custom parameters to pass in a Facebook OAuth request
  /// for popup and redirect sign-in operations.
  /// Valid parameters include 'auth_type', 'display' and 'locale'.
  /// For a detailed list, check the Facebook documentation.
  /// Reserved required OAuth 2.0 parameters such as 'client_id',
  /// 'redirect_uri', 'scope', 'response_type' and 'state' are not allowed
  /// and ignored.
  FacebookAuthProvider setCustomParameters(
          Map<String, dynamic> customOAuthParameters) =>
      new FacebookAuthProvider.fromJsObject(
          jsObject.setCustomParameters(jsify(customOAuthParameters)));

  /// Creates a credential for Facebook.
  static AuthCredential credential(String token) =>
      FacebookAuthProviderJsImpl.credential(token);
}

/// Github auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.GithubAuthProvider>.
class GithubAuthProvider extends AuthProvider<GithubAuthProviderJsImpl> {
  static String PROVIDER_ID = GithubAuthProviderJsImpl.PROVIDER_ID;

  /// Creates a new GithubAuthProvider.
  factory GithubAuthProvider() =>
      new GithubAuthProvider.fromJsObject(new GithubAuthProviderJsImpl());

  /// Creates a new GithubAuthProvider from a [jsObject].
  GithubAuthProvider.fromJsObject(GithubAuthProviderJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Adds additional OAuth 2.0 scopes that you want to request from the
  /// authentication provider.
  GithubAuthProvider addScope(String scope) =>
      new GithubAuthProvider.fromJsObject(jsObject.addScope(scope));

  /// Sets the OAuth custom parameters to pass in a GitHub OAuth request
  /// for popup and redirect sign-in operations.
  /// Valid parameters include 'allow_signup'.
  /// For a detailed list, check the GitHub documentation.
  /// Reserved required OAuth 2.0 parameters such as 'client_id',
  /// 'redirect_uri', 'scope', 'response_type' and 'state'
  /// are not allowed and ignored.
  GithubAuthProvider setCustomParameters(
          Map<String, dynamic> customOAuthParameters) =>
      new GithubAuthProvider.fromJsObject(
          jsObject.setCustomParameters(jsify(customOAuthParameters)));

  /// Creates a credential for GitHub.
  static AuthCredential credential(String token) =>
      GithubAuthProviderJsImpl.credential(token);
}

/// Google auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.GoogleAuthProvider>.
class GoogleAuthProvider extends AuthProvider<GoogleAuthProviderJsImpl> {
  static String PROVIDER_ID = GoogleAuthProviderJsImpl.PROVIDER_ID;

  /// Creates a new GoogleAuthProvider.
  factory GoogleAuthProvider() =>
      new GoogleAuthProvider.fromJsObject(new GoogleAuthProviderJsImpl());

  /// Creates a new GoogleAuthProvider from a [jsObject].
  GoogleAuthProvider.fromJsObject(GoogleAuthProviderJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Adds additional OAuth 2.0 scopes that you want to request from the
  /// authentication provider.
  GoogleAuthProvider addScope(String scope) =>
      new GoogleAuthProvider.fromJsObject(jsObject.addScope(scope));

  /// Sets the OAuth custom parameters to pass in a Google OAuth request
  /// for popup and redirect sign-in operations.
  /// Valid parameters include 'hd', 'hl', 'include_granted_scopes',
  /// 'login_hint' and 'prompt'.
  /// For a detailed list, check the Google documentation.
  /// Reserved required OAuth 2.0 parameters such as 'client_id',
  /// 'redirect_uri', 'scope', 'response_type' and 'state'
  /// are not allowed and ignored.
  GoogleAuthProvider setCustomParameters(
          Map<String, dynamic> customOAuthParameters) =>
      new GoogleAuthProvider.fromJsObject(
          jsObject.setCustomParameters(jsify(customOAuthParameters)));

  /// Creates a credential for Google.
  /// At least one of [idToken] and [accessToken] is required.
  static AuthCredential credential([String idToken, String accessToken]) =>
      GoogleAuthProviderJsImpl.credential(idToken, accessToken);
}

/// Twitter auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.TwitterAuthProvider>.
class TwitterAuthProvider extends AuthProvider<TwitterAuthProviderJsImpl> {
  static String PROVIDER_ID = TwitterAuthProviderJsImpl.PROVIDER_ID;

  /// Creates a new TwitterAuthProvider.
  factory TwitterAuthProvider() =>
      new TwitterAuthProvider.fromJsObject(new TwitterAuthProviderJsImpl());

  /// Creates a new TwitterAuthProvider from a [jsObject].
  TwitterAuthProvider.fromJsObject(TwitterAuthProviderJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Sets the OAuth custom parameters to pass in a Twitter OAuth request
  /// for popup and redirect sign-in operations.
  /// Valid parameters include 'lang'. Reserved required OAuth 1.0 parameters
  /// such as 'oauth_consumer_key', 'oauth_token', 'oauth_signature', etc
  /// are not allowed and will be ignored.
  TwitterAuthProvider setCustomParameters(
          Map<String, dynamic> customOAuthParameters) =>
      new TwitterAuthProvider.fromJsObject(
          jsObject.setCustomParameters(jsify(customOAuthParameters)));

  /// Creates a credential for Twitter.
  static AuthCredential credential(String token, String secret) =>
      TwitterAuthProviderJsImpl.credential(token, secret);
}

/// Phone number auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.PhoneAuthProvider>.
class PhoneAuthProvider extends AuthProvider<PhoneAuthProviderJsImpl> {
  static String get PROVIDER_ID => PhoneAuthProviderJsImpl.PROVIDER_ID;

  /// Creates a new PhoneAuthProvider with the optional [Auth] instance
  /// in which sign-ins should occur.
  factory PhoneAuthProvider([Auth auth]) =>
      new PhoneAuthProvider.fromJsObject((auth != null)
          ? new PhoneAuthProviderJsImpl(auth.jsObject)
          : new PhoneAuthProviderJsImpl());

  /// Creates a new PhoneAuthProvider from a [jsObject].
  PhoneAuthProvider.fromJsObject(PhoneAuthProviderJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Starts a phone number authentication flow by sending a verification code
  /// to the given [phoneNumber] in E.164 format (e.g. +16505550101).
  /// Returns an ID that can be passed to [PhoneAuthProvider.credential]
  /// to identify this flow.
  ///
  /// For abuse prevention, this method also requires an [ApplicationVerifier].
  Future<String> verifyPhoneNumber(
          String phoneNumber, ApplicationVerifier applicationVerifier) =>
      handleThenable(jsObject.verifyPhoneNumber(
          phoneNumber, applicationVerifier.jsObject));

  /// Creates a phone auth credential given the verification ID
  /// from [verifyPhoneNumber] and the [verificationCode] that was sent to the
  /// user's mobile device.
  static AuthCredential credential(
          String verificationId, String verificationCode) =>
      PhoneAuthProviderJsImpl.credential(verificationId, verificationCode);
}

/// A verifier for domain verification and abuse prevention.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.ApplicationVerifier>
abstract class ApplicationVerifier<T extends ApplicationVerifierJsImpl>
    extends JsObjectWrapper<T> {
  /// Returns the type of application verifier (e.g. "recaptcha").
  String get type => jsObject.type;

  /// Creates a new ApplicationVerifier from a [jsObject].
  ApplicationVerifier.fromJsObject(T jsObject) : super.fromJsObject(jsObject);

  /// Executes the verification process.
  /// Returns a Future containing string for a token that can be used to
  /// assert the validity of a request.
  Future<String> verify() => handleThenable(jsObject.verify());
}

/// reCAPTCHA verifier.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.RecaptchaVerifier>
/// See: <https://www.google.com/recaptcha/>
class RecaptchaVerifier extends ApplicationVerifier<RecaptchaVerifierJsImpl> {
  /// Creates a new RecaptchaVerifier from [container], [parameters] and [app].
  ///
  /// The [container] has different meaning depending on whether the reCAPTCHA
  /// is hidden or visible. For a visible reCAPTCHA it must be empty.
  /// If a string is used, it has to correspond to an element ID.
  /// The corresponding element must also must be in the DOM at the time
  /// of initialization.
  ///
  /// The [parameters] are optional [Map] of Recaptcha parameters.
  /// See: <https://developers.google.com/recaptcha/docs/display#render_param>.
  /// All parameters are accepted except for the sitekey.
  /// Firebase Auth backend provisions a reCAPTCHA for each project
  /// and will configure this upon rendering.
  /// For an invisible reCAPTCHA, a size key must have the value 'invisible'.
  ///
  /// The [app] is the corresponding Firebase app.
  /// If none is provided, the default Firebase App instance is used.
  ///
  ///     verifier = new fb.RecaptchaVerifier("register", {
  ///       "size": "invisible",
  ///       "callback": (resp) {
  ///         print("Successful reCAPTCHA response");
  ///       },
  ///       "expired-callback": () {
  ///         print("Response expired");
  ///       }
  ///     });
  factory RecaptchaVerifier(container,
          [Map<String, dynamic> parameters, App app]) =>
      (parameters != null)
          ? ((app != null)
              ? new RecaptchaVerifier.fromJsObject(new RecaptchaVerifierJsImpl(
                  container, jsify(parameters), app.jsObject))
              : new RecaptchaVerifier.fromJsObject(
                  new RecaptchaVerifierJsImpl(container, jsify(parameters))))
          : new RecaptchaVerifier.fromJsObject(
              new RecaptchaVerifierJsImpl(container));

  /// Creates a new RecaptchaVerifier from a [jsObject].
  RecaptchaVerifier.fromJsObject(RecaptchaVerifierJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Clears the reCAPTCHA widget from the page and destroys the current instance.
  clear() => jsObject.clear();

  /// Renders the reCAPTCHA widget on the page.
  /// Returns a Future that resolves with the reCAPTCHA widget ID.
  Future<num> render() => handleThenable(jsObject.render());
}

/// A result from a phone number sign-in, link, or reauthenticate call.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.ConfirmationResult>
class ConfirmationResult extends JsObjectWrapper<ConfirmationResultJsImpl> {
  /// Returns the phone number authentication operation's verification ID.
  /// This can be used along with the verification code to initialize a phone
  /// auth credential.
  String get verificationId => jsObject.verificationId;

  /// Creates a new ConfirmationResult from a [jsObject].
  ConfirmationResult.fromJsObject(ConfirmationResultJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Finishes a phone number sign-in, link, or reauthentication, given
  /// the code that was sent to the user's mobile device.
  Future<UserCredential> confirm(String verificationCode) =>
      handleThenableWithMapper(jsObject.confirm(verificationCode),
          (u) => new UserCredential.fromJsObject(u));
}

/// A structure containing a [User], an [AuthCredential] and [operationType].
/// operationType could be 'signIn' for a sign-in operation, 'link' for a
/// linking operation and 'reauthenticate' for a reauthentication operation.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth#.UserCredential>
class UserCredential extends JsObjectWrapper<UserCredentialJsImpl> {
  /// Returns the user.
  User get user => User.get(jsObject.user);

  /// Returns the auth credential.
  AuthCredential get credential => jsObject.credential;

  /// Returns the operation type.
  String get operationType => jsObject.operationType;

  /// Returns additional user information from a federated identity provider.
  AdditionalUserInfo get additionalUserInfo =>
      new AdditionalUserInfo.fromJsObject(jsObject.additionalUserInfo);

  /// Creates a new UserCredential from a [jsObject].
  UserCredential.fromJsObject(UserCredentialJsImpl jsObject)
      : super.fromJsObject(jsObject);
}

/// A structure containing additional user information from
/// a federated identity provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth#.AdditionalUserInfo>
class AdditionalUserInfo extends JsObjectWrapper<AdditionalUserInfoJsImpl> {
  /// Returns the provider id.
  String get providerId => jsObject.providerId;

  /// Returns the profile.
  Map<String, dynamic> get profile => dartify(jsObject.profile);

  /// Returns the user name.
  String get username => jsObject.username;

  /// Creates a new AdditionalUserInfo from a [jsObject].
  AdditionalUserInfo.fromJsObject(AdditionalUserInfoJsImpl jsObject)
      : super.fromJsObject(jsObject);
}