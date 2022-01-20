function inputCheck(){
	if(document.regFrm.id.value == ""){
			alert("아이디를 입력해 주세요.");
			document.regFrm.id.focus();
			return;
	}

	let pwd = document.regFrm.pwd;
	let repwd = document.regFrm.repwd;
	if(pwd.value == ""){
			alert("비밀번호를 입력해 주세요.");
			pwd.focus();
			return;
	}

	if(repwd.value == ""){
			alert("비밀번호 확인을 입력해 주세요.");
			repwd.focus();
			return;
	}

	if(pwd.value != repwd.value){
			alert("비밀번호가 일치하지 않습니다.");
			pwd.value = "";
			repwd.value = "";
			pwd.focus();
			return;
	}

	if(document.regFrm.name.value == ""){
			alert("이름을 입력해 주세요.");
			document.regFrm.name.focus();
			return;
	}

	if(document.regFrm.gender.value == ""){
			alert("성별을 입력해 주세요.");
			document.regFrm.gender.focus();
			return;
	}

	if(document.regFrm.birthday.value == ""){
			alert("생년월일을 입력해 주세요.");
			document.regFrm.birthday.focus();
			return;
	}

	let email = document.regFrm.email;
	if(email.value == ""){
			alert("이메일을 입력해 주세요.");
			email.focus();
			return;
	}

	let eStr = email.value;
	let atPos = eStr.indexOf("@");
	let atLastPos = eStr.lastIndexOf("@");
	let dotPos = eStr.indexOf(".");
	let spacePos = eStr.indexOf(" ");
	let commaPos = eStr.indexOf(",");
	let eMailSize = eStr.length;
	if(atPos > 1 && atPos == atLastPos && dotPos > 3 
			&& spacePos == -1 && commaPos == -1 
			&& atPos < dotPos && dotPos + 1 < eMailSize){

			} else {
					alert("E-mail 주소 형식이 잘못 되었습니다. \n다시 입력해 주세요!");
					email.focus();
					return;
			}

	if(document.regFrm.zipcode.value == ""){
			alert("우편번호를 검색해 주세요.");
			document.regFrm.zipcode.focus();
			return;
	}

	if(document.regFrm.birthday.value == ""){
			alert("생년월일을 입력해 주세요.");
			document.regFrm.birthday.focus();
			return;
	}

	if(document.regFrm.job.value == 0){
			alert("직업을 선택해 주세요.");
			document.regFrm.job.focus();
			return;
	}

	document.regFrm.submit();
}