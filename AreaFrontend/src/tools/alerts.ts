import 'react-toastify/dist/ReactToastify.css';
import {toast} from 'react-toastify';

const callSuccessPopup = (message: string) => {
  toast.success(message, {
    position: toast.POSITION.TOP_RIGHT,
  });
}

const callLoadingPopup = (message: string) => {
  toast.info(message, {
    position: toast.POSITION.TOP_RIGHT,
  });
}

const callErrorPopup = (message: string) => {
  toast.error(message, {
    position: toast.POSITION.TOP_RIGHT,
  });
}

export {callSuccessPopup, callLoadingPopup, callErrorPopup};
