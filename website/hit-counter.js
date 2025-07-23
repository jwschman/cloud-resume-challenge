document.addEventListener('DOMContentLoaded', () => {
    const dataContainer = document.getElementById('data');
    const errorContainer = document.getElementById('error');

    // Clear previous data and errors
    dataContainer.textContent = '';
    errorContainer.textContent = '';

    fetch("https://i13nr94ldj.execute-api.ap-northeast-1.amazonaws.com/stage/hit-counter", {
        method: "POST",
        headers: {
            "Content-type": "application/json; charset=UTF-8"
        }
    })
        .then(response => {
            if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
            }
            return response.json();
        })
        .then(parsedData => {
            dataContainer.textContent = `This page has been viewed ${parsedData["hit-count"]} times`;
        })
        .catch(error => {
            errorContainer.textContent = `Error fetching data: ${error.message}`;
        });
    });