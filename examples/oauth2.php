<?php

/**
 * Replace the values below with your integration's information found on the marketplace build page.
 * https://marketplace.teamleader.eu/eu/en/build/integrations
 */
$clientId = 'YOUR-CLIENT-ID';
$clientSecret = 'YOUR-CLIENT-SECRET';

/**
 * Where to redirect to after the OAuth 2 flow was completed.
 * Make sure this matches the information of your integration settings on the marketplace build page.
 */
$redirectUri = 'http://localhost:3000/oauth.php';

/* ------------------------------------------------------------------------------------------------- */

/**
 * When the OAuth2 authentication flow was completed, the user is redirected back with a code.
 * If we received the code, we can get an access token and make API calls. Otherwise we redirect
 * the user to the OAuth2 authorization endpoints.
 */
if (!empty($_GET['code'])) {

    $code = rawurldecode($_GET['code']);

    /**
     * Request an access token based on the received authorization code.
     */
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, 'https://app.teamleader.eu/oauth2/access_token');
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, [
        'code' => $code,
        'client_id' => $clientId,
        'client_secret' => $clientSecret,
        'redirect_uri' => $redirectUri,
        'grant_type' => 'authorization_code',
    ]);

    $response = curl_exec($ch);
    $data = json_decode($response, true);
    $accessToken = $data['access_token'];

    /**
     * Get the user identity information using the access token.
     */
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, 'https://api.teamleader.eu/users.me');
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Authorization: Bearer ' . $accessToken]);

    $response = curl_exec($ch);
    $data = json_decode($response, true);

    echo $response;

} else {

    $query = [
        'client_id' => $clientId,
        'response_type' => 'code',
        'redirect_uri' => $redirectUri,
    ];

    header('Location: https://app.teamleader.eu/oauth2/authorize?' . http_build_query($query));

}
