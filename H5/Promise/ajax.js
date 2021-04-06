function ajax(url, callback) {
  let xhr = new XMLHttpRequest();
  xhr.open("GET", url);
  xhr.setRequestHeader("Content-Type", "application/json");

  xhr.send();
  xhr.onload = () => {
    if (this.status == 200) {
      console.log(this.response);
      callback(JSON.parse(this.response));
    } else {
      throw new Error("load failure");
    }
  };
}
