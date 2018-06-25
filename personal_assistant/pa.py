import speech_recognition
import pyttsx

#speech_engine = pyttsx.init('sapi5') # see http://pyttsx.readthedocs.org/en/latest/engine.html#pyttsx.init
speech_engine = pyttsx.init();
speech_engine.setProperty('rate', 150)

def speak(text):
	speech_engine.say(text)
	speech_engine.runAndWait()

recognizer = speech_recognition.Recognizer()

def listen():
    try:
        print("A moment of silence, please...")
        with speech_recognition.Microphone() as source: recognizer.adjust_for_ambient_noise(source)
        print("Set minimum energy threshold to {}".format(recognizer.energy_threshold))
        while True:
            print("Say something!")
            with speech_recognition.Microphone() as source: audio = recognizer.listen(source)
            print("Got it! Now to recognize it...")
            try:
                # recognize speech using Google Speech Recognition
                value = recognizer.recognize_google(audio)

                # we need some special handling here to correctly print unicode characters to standard output
                if str is bytes: # this version of Python uses bytes for strings (Python 2)
                    print(u"You said {}".format(value).encode("utf-8"))
                else: # this version of Python uses unicode for strings (Python 3+)
                    print("You said {}".format(value))
            except speech_recognition.UnknownValueError:
                print("Oops! Didn't catch that")
            except speech_recognition.RequestError as e:
                print("Uh oh! Couldn't request results from Google Speech Recognition service; {0}".format(e))
    except KeyboardInterrupt:
        pass

listen()
