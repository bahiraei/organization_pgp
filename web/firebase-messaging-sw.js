importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

/*importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");*/
/*
importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js');*/


  const firebaseConfig = {
        apiKey: "AIzaSyDFRIO3sqJzglgF8XEwIJGdVPlsndx30H0",
        authDomain: "hedayatpgp.firebaseapp.com",
        projectId: "hedayatpgp",
        storageBucket: "hedayatpgp.appspot.com",
        messagingSenderId: "487002396898",
        appId: "1:487002396898:web:7a7ed818d86c5deb2ba6bb"
    };

  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();


/*
  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });*/
