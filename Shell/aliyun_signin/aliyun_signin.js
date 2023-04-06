/**
 * @author Anonym-w
 */

const fetch = require("node-fetch");
const updateAccesssTokenURL = "https://auth.aliyundrive.com/v2/account/token"
const signinURL = "https://member.aliyundrive.com/v1/activity/sign_in_list"
const refreshToeknArry = [
    "refresh token"
]

!(async() => {
    for (const elem of refreshToeknArry) {
        const queryBody = {
            'grant_type': 'refresh_token',
            'refresh_token': elem
        };

        fetch(updateAccesssTokenURL, {
            method: "POST",
            body: JSON.stringify(queryBody),
		    headers: {'Content-Type': 'application/json'}
        })
        .then((res) => res.json())
        .then((json) => {
            let access_token = json.access_token;
            console.log(access_token);

            //签到
            fetch(signinURL, {
                method: "POST",
                body: JSON.stringify(queryBody),
                headers: {'Authorization': 'Bearer '+access_token,'Content-Type': 'application/json'}
            })
            .then((res) => res.json())
            .then((json) => {
                console.log(json);
            })
            .catch((err) => console.log(err))
        })
        .catch((err) => console.log(err))
    }

})().catch((e) => {
    console.error(`运行错误！\n${e}`)
}).finally()
