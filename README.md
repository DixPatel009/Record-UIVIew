# Record-UIVIew


Record-UIVIew is a simple library that allows you to create videos from UIViews.  It records animations and actions as they happen by taking screen shots of a UIView in a series and then creating a video and saving it to your app’s document folder.

## Setup
To setup Record-UIVIew, add the `Recorder.swift`and `ImageToVideo.swift` file to your project.


## Example Usage

### For Swift


   class viewController: UIViewController {
    
    @IBOutlet weak var screenRecoderView: UIView!
    
    private var screenRecorder = Recorder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenRecorder.view = self.screenRecoderView
    }
    
    @IBAction func startRecordAction(_ sender: UIButton) {
        self.screenRecorder.start()
    }
    
    @IBAction func StopRecordAction(_ sender: UIButton) {
        self.screenRecorder.stop { (strUrl) in
            print("Final Video Document Direcotry URL : " + strUrl)
        }
    }
    
    }


