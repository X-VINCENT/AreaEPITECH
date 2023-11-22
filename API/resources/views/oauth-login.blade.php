<!DOCTYPE html>
<html>
<head>
    <title>OAuth Login Test</title>
</head>
<body>
<h1>OAuth Login Test</h1>

<p>Click the buttons below to login with different OAuth providers:</p>

<!-- Google Login Button -->
<a href="{{ url('/api/auth/google') }}">Login with Google</a><br>

<!-- GitHub Login Button -->
<a href="{{ url('/api/auth/github') }}">Login with GitHub</a><br>

<!-- GitLab Login Button -->
<a href="{{ url('/api/auth/gitlab') }}">Login with GitLab</a><br>

</body>
</html>
