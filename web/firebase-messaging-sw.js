importScripts('https://www.gstatic.com/firebasejs/9.22.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.22.2/firebase-messaging-compat.js');

firebase.initializeApp({
    apiKey: 'AIzaSyBcpCuHKsRjoDkOAfOoT92H5Hrl3HNbtGs',
    appId: '1:344570934631:web:fec9a9525662db01402bc2',
    messagingSenderId: '344570934631',
    projectId: 'serviceprovideriumi',
    authDomain: 'serviceprovideriumi.firebaseapp.com',
    storageBucket: 'serviceprovideriumi.firebasestorage.app',
    measurementId: 'G-DXP80VXNJX',
});

const messaging = firebase.messaging();