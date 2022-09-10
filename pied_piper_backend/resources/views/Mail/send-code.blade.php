@component('mail::message')
    <h1>We have received your request to {{$action}}</h1>
    <p>You can use the following code to recover your account:</p>
    <p>your code is: {{ $code }}</p>
    <p>The allowed duration of the code is one hour from the time the message was sent</p>
@endcomponent

