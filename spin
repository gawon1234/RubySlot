using UnityEngine;
using System.Collections;
using System.Linq;
using UnityEngine.UI;


[RequireComponent(typeof(Button))]
public class Spin : MonoBehaviour {
	
	public bool finishedLastSpin;
	public bool finishedLastSpin_history;
	public float speed; //spinning speed
	
	public int how_many_bonus;
	public int how_many_lucky;
	
	GameObject[] row1;
	GameObject[] row2;
	GameObject[] row3;
	GameObject[] row4;
	GameObject[] row5;
	
	GameObject[] Row1sPos;
	GameObject[] Row2sPos;
	GameObject[] Row3sPos;
	GameObject[] Row4sPos;
	GameObject[] Row5sPos;
	
	bool isSpinning1;
	bool isSpinning2;
	bool isSpinning3;
	bool isSpinning4;
	bool isSpinning5;
	
	float spinningTime1;
	float spinningTime2;
	float spinningTime3;
	float spinningTime4;
	float spinningTime5;
	
	Animator anim;
	public int bonus_count;
	
	GameObject[] lucky_arry;
	GameObject[] bonus_arry;
	GameObject[] wild_arry;
	int spin_cnt;
	int lucky_count;
	int wild_count;
	public int autospin_cnt;
	int glinda_count;
	int set_glinda_count;
	GameObject[] symbol_anis;
	
	MatchingLine matchingLinePage;
	Score scorePage;
	moveCamera movecameraPage;
	Bonus_GameC bonusgamecPage;
	Glinda glindaPage;
	Sound soundPage;
	triggered triggeredPage;
	Timer timerPage;
	level_up level_upPage;
	
	public Slider exp_bar;
	public Sprite autoButton;	
	public Sprite spinButton;
	Image spinButtonImg;
	
	GameObject ui_mini_Freespin;
	Text how_many_freespin;

	public GameObject game_camera;

	public int glinda_min;
	public int glinda_max;
	bool glinda_duration;

	GameObject bonus_start_notice;
	GameObject lucky_start_notice;
	Text lucky_count_txt;

	GameObject level_up_notice;

	void Awake(){
		
		matchingLinePage = GameObject.FindObjectOfType(typeof(MatchingLine)) as MatchingLine;
		scorePage = GameObject.FindObjectOfType(typeof(Score)) as Score;
		movecameraPage = GameObject.FindObjectOfType(typeof(moveCamera)) as moveCamera;
		bonusgamecPage = GameObject.FindObjectOfType(typeof(Bonus_GameC)) as Bonus_GameC;
		glindaPage = GameObject.FindObjectOfType(typeof(Glinda)) as Glinda;
		symbol_anis = GameObject.FindGameObjectsWithTag("symbol_ani");
		soundPage = GameObject.FindObjectOfType(typeof(Sound)) as Sound;
		timerPage = GameObject.FindObjectOfType(typeof(Timer)) as Timer;
		triggeredPage = GameObject.FindObjectOfType(typeof(triggered)) as triggered;
		level_upPage = GameObject.FindObjectOfType(typeof(level_up)) as level_up;
	}
	
	// Use this for initialization
	void Start () {
		spin_cnt = 0;
		glinda_count = 0;
		autospin_cnt = 0;
		bonus_count = 0;
		lucky_count = 0;
		wild_count = 0;
		
		lucky_arry = new GameObject[20];
		bonus_arry = new GameObject[20];
		wild_arry = new GameObject[20];

		
		if(speed == 0)
			speed = 50.0f;
		if(how_many_bonus == 0)
			how_many_bonus = 3;
		if(how_many_lucky == 0)
			how_many_lucky = 7;


		if(glinda_min == 0 || glinda_max == 0 || glinda_min > glinda_max){
			glinda_max = 10;
			glinda_min = 5;
		}

		set_glinda_count = Random.Range(glinda_min,glinda_max);

		bonusgamecPage.hide_Bonus_Canvas();

		row1 = GameObject.FindGameObjectsWithTag("row1img");
		row2 = GameObject.FindGameObjectsWithTag("row2img");
		row3 = GameObject.FindGameObjectsWithTag("row3img");
		row4 = GameObject.FindGameObjectsWithTag("row4img");
		row5 = GameObject.FindGameObjectsWithTag("row5img");
		
		
		Row1sPos = GameObject.FindGameObjectsWithTag("row1pos").OrderBy(go => go.transform.position.y).ToArray();
		Row2sPos = GameObject.FindGameObjectsWithTag("row2pos").OrderBy(go6 => go6.transform.position.y).ToArray();
		Row3sPos = GameObject.FindGameObjectsWithTag("row3pos").OrderBy(go2 => go2.transform.position.y).ToArray();
		Row4sPos = GameObject.FindGameObjectsWithTag("row4pos").OrderBy(go2 => go2.transform.position.y).ToArray();
		Row5sPos = GameObject.FindGameObjectsWithTag("row5pos").OrderBy(go2 => go2.transform.position.y).ToArray();
		
		spinningTime5 = 3.5f;
		spinningTime4 = 3.0f;
		spinningTime3 = 2.5f;
		spinningTime2 = 2.0f;
		spinningTime1 = 1.6f;
		
		isSpinning1 = false;
		isSpinning2 = false;
		isSpinning3 = false;
		isSpinning4 = false;
		isSpinning5 = false;
		
		finishedLastSpin_history = false;
		
		exp_bar.maxValue = 2;
		exp_bar.value = 0; //PlayerPrefs.GetInt("exp");

		spinButtonImg = GameObject.Find("Spin").GetComponent<Image>();
		how_many_freespin = GameObject.Find("how_many_freespin").GetComponent<Text>();
		ui_mini_Freespin = GameObject.Find("mini_Freespin");
		ui_mini_Freespin.SetActive(false);
		soundPage.bg_sound_Clk_Sound();
		game_camera = GameObject.Find("Main Camera");

		glinda_duration = false;

		bonus_start_notice = GameObject.Find("bonus_start_notice");
		lucky_start_notice =  GameObject.Find("lucky_start_notice");
		lucky_count_txt = GameObject.Find("lucky_count").GetComponent<Text>();
		bonus_start_notice.SetActive(false);
		lucky_start_notice.SetActive(false);

		level_up_notice = GameObject.Find("level_up_notice");
		level_up_notice.SetActive(false);
	}
	
	// Update is called once per frame
	void Update () {
		if(isSpinning1 == true){

			spinningTime1 -= Time.deltaTime;
			if(spinningTime1 > 0){
				spinWheelRow1();
				
			}
			else{
				setStopPos1();
				isSpinning1 = false;
				//soundPage.Stop1_Clk_Sound();
				
			}
			
		}
		if(isSpinning2 == true){
			spinningTime2 -= Time.deltaTime;
			if(spinningTime2 > 0){
				spinWheelRow2();
			}
			else{
				setStopPos2();
				isSpinning2 = false;
				//soundPage.Stop2_Clk_Sound();
				
			}
		}
		if(isSpinning3 == true){
			spinningTime3 -= Time.deltaTime;
			
			if(spinningTime3 > 0){
				spinWheelRow3();
			}
			else{
				setStopPos3();
				isSpinning3 = false;
				//soundPage.Stop1_Clk_Sound();
				
			}
		}
		
		if(isSpinning4 == true){
			spinningTime4 -= Time.deltaTime;
			
			if(spinningTime4 > 0){
				spinWheelRow4();
			}
			else{
				setStopPos4();
				isSpinning4 = false;
				//soundPage.Stop1_Clk_Sound();
				
			}
		}
		
		if(isSpinning5 == true){
			if(GameObject.Find("Spin"))
				GameObject.Find("Spin").GetComponent<Button>().interactable = false;

			spinningTime5 -= Time.deltaTime;
			
			if(spinningTime5 > 0){
				spinWheelRow5();
			}
			else{
				setStopPos5();
				isSpinning5 = false;
				finishedLastSpin = true;
				
				if(finishedLastSpin_history == true){
					finishedLastSpin_history = false;
				}
				
				//soundPage.Stop2_Clk_Sound();
				StartCoroutine( matchingLinePage.MatchingImg());
			}

			
		}		
		
		else{
			spinningTime5 = 3.5f;
			spinningTime4 = 3.0f;
			spinningTime3 = 2.5f;
			spinningTime2 = 2.0f;
			spinningTime1 = 1.5f;
			
			if(autospin_cnt <= 0){
				if(GameObject.Find("Spin") && glinda_duration == false)
					GameObject.Find("Spin").GetComponent<Button>().interactable = true;
				
				spinButtonImg.sprite = spinButton;
				
			}
		}

	}
	
	public void Spin_Clicked(){
		scorePage.disable_coin_flood();
		all_anim_stop();
		triggeredPage.setArray();

		if(scorePage.TTL >= scorePage.BET  && GameObject.Find("Main").activeSelf){

			spin_cnt++;
		//	Debug.Log("spiin clicked" + spin_cnt);
			exp_bar.value += scorePage.BET; 

			bonus_count = 0;
			lucky_count = 0;
			wild_count = 0;
			matchingLinePage.disable_Borders_and_lines();
			//matchingLinePage.disable_line();
			
			scorePage.deduct_bet();
			
			isSpinning1 = true;
			isSpinning2 = true;
			isSpinning3 = true;
			isSpinning4 = true;
			isSpinning5 = true;
			
			finishedLastSpin = false;
			finishedLastSpin_history = true;

			//Debug.Log("glinda count  "+ glinda_count + " " + set_glinda_count + " &&&& lucky count is " + autospin_cnt );

			if(glinda_count+1 > set_glinda_count)
			 StartCoroutine(	glinda_counter_func());
			if(autospin_cnt == 0){
			//	Debug.Log("lucky count is " + lucky_count);
				glinda_count++;
			}
		}

		timerPage.Spin_Clicked_Timer = 100.0f;

		Debug.Log(" EXP VALUE : "+ exp_bar.value +  " & EXP MAX VALUE : "  +  exp_bar.maxValue);


	}

	
	void spinWheelRow1(){
		
		foreach(GameObject img in row1){
			img.transform.position = Vector3.MoveTowards(img.transform.position, new Vector3(img.transform.position.x, img.transform.position.y - 1, img.transform.position.z), speed * Time.deltaTime);
			
		}
	}
	
	
	void spinWheelRow2(){
		foreach(GameObject img in row2){
			img.transform.position = Vector3.MoveTowards(img.transform.position, new Vector3(img.transform.position.x, img.transform.position.y - 1, img.transform.position.z), speed * Time.deltaTime);
		}
		
	}
	
	void spinWheelRow3(){
		foreach(GameObject img in row3){
			img.transform.position = Vector3.MoveTowards(img.transform.position, new Vector3(img.transform.position.x, img.transform.position.y - 1, img.transform.position.z), speed * Time.deltaTime);
		}
	}
	
	void spinWheelRow4(){
		foreach(GameObject img in row4){
			img.transform.position = Vector3.MoveTowards(img.transform.position, new Vector3(img.transform.position.x, img.transform.position.y - 1, img.transform.position.z), speed * Time.deltaTime);
		}
	}
	
	void spinWheelRow5(){
		foreach(GameObject img in row5){
			img.transform.position = Vector3.MoveTowards(img.transform.position, new Vector3(img.transform.position.x, img.transform.position.y - 1, img.transform.position.z), speed * Time.deltaTime);
		}

		foreach(GameObject go in symbol_anis){
			go.SetActive(true);
		}
	}
	
	
	int findImgID(string name){
		
		if(name == "a")
			return 0;
		else if(name == "b")
			return 1;
		else if(name == "c")
			return 2;
		else if(name == "d")
			return 3;
		else if(name == "e")
			return 4;
		else if(name == "f")
			return 5;
		else if(name == "h")
			return 6;
		else if(name == "lucky")
			return 7;
		else if(name == "bonus")
			return 8;
		else if(name == "wild")
			return 10;
		else 
			return -1;
	}
	
	
	void setStopPos1(){
		int i;	
		row1 = row1.OrderBy(go => go.transform.position.y).ToArray();
		i=0;
		foreach(GameObject img in row1){
			LeanTween.move(img, Row1sPos[i].transform.position, 1.0f).setEase(LeanTweenType.easeOutBounce);
			
			int temp = findImgID( img.GetComponent<SpriteRenderer>().sprite.name);
			matchingLinePage.imgid_row1pos[i] = temp;

			if(temp == 9 ){
				bonus_count++;
			}
			else if (temp == 7){
				lucky_arry[lucky_count] = Row1sPos[i];
				//	Debug.Log(" pos name is " + Row1sPos[i].name);
				lucky_count++;
			}
			else if (temp == 8){//bonus
				bonus_arry[bonus_count] = Row1sPos[i];
				bonus_count++;
			}
			else if(temp == 10){// wild
				wild_arry[wild_count] = Row1sPos[i];
				wild_count++;
				
			}
			
			
			i++;
			
		}
		
		
	}
	
	
	void setStopPos2(){
		
		int i;	
		row2 = row2.OrderBy(go => go.transform.position.y).ToArray();
		i=0;
		foreach(GameObject img in row2){
			LeanTween.move(img, Row2sPos[i].transform.position, 1.0f).setEase(LeanTweenType.easeOutBounce);
			
			int temp =  findImgID( img.GetComponent<SpriteRenderer>().sprite.name);
			matchingLinePage.imgid_row2pos[i] = temp;
			
			if(temp == 9 ){
				bonus_count++;
			}
			else if (temp == 7){
				lucky_arry[lucky_count] = Row2sPos[i];
				//	Debug.Log(" pos name is " + Row2sPos[i].name);
				lucky_count++;
			}
			else if (temp == 8){//bonus
				bonus_arry[bonus_count] = Row2sPos[i];
				
				bonus_count++;
			}
			else if(temp == 10){// wild
				wild_arry[wild_count] = Row2sPos[i];
				wild_count++;
				
			}
			
			i++;
		}
		
	}
	
	
	void  setStopPos3(){
		int i;	
		row3 = row3.OrderBy(go => go.transform.position.y).ToArray();
		i=0;
		foreach(GameObject img in row3){
			LeanTween.move(img, Row3sPos[i].transform.position, 1.0f).setEase(LeanTweenType.easeOutBounce);
			
			int temp =   findImgID( img.GetComponent<SpriteRenderer>().sprite.name);
			matchingLinePage.imgid_row3pos[i] = temp;
			
			if(temp == 9 ){
				bonus_count++;
			}
			else if (temp == 7){
				lucky_arry[lucky_count] = Row3sPos[i];
				//Debug.Log(" pos name is " + Row3sPos[i].name);
				lucky_count++;
			}
			else if (temp == 8){//bonus
				bonus_arry[bonus_count] = Row3sPos[i];
				
				bonus_count++;
			}
			else if(temp == 10){// wild
				
				wild_arry[wild_count] = Row3sPos[i];
				wild_count++;
				
			}
			
			i++;
		}
		
	}
	
	void setStopPos4(){
		int i;	
		row4 = row4.OrderBy(go => go.transform.position.y).ToArray();
		i=0;
		foreach(GameObject img in row4){
			LeanTween.move(img, Row4sPos[i].transform.position, 1.0f).setEase(LeanTweenType.easeOutBounce);
			
			int temp =  findImgID( img.GetComponent<SpriteRenderer>().sprite.name);
			matchingLinePage.imgid_row4pos[i] = temp;
			
			
			if(temp == 9 ){
				bonus_count++;
			}
			else if (temp == 7){
				lucky_arry[lucky_count] = Row4sPos[i];
				//Debug.Log(" pos name is " + Row4sPos[i].name);
				
				lucky_count++;
			}
			else if (temp == 8){//bonus
				bonus_arry[bonus_count] = Row4sPos[i];
				
				bonus_count++;
			}
			else if(temp == 10){// wild
				
				wild_arry[wild_count] = Row4sPos[i];
				wild_count++;
				
			}
			i++;
		}
		
	}
	
	void  setStopPos5(){
		int i;	
		row5 = row5.OrderBy(go => go.transform.position.y).ToArray();
		i=0;
		foreach(GameObject img in row5){
			LeanTween.move(img, Row5sPos[i].transform.position, 1.0f).setEase(LeanTweenType.easeOutBounce);
			
			int temp =  findImgID( img.GetComponent<SpriteRenderer>().sprite.name);
			matchingLinePage.imgid_row5pos[i] = temp;
			
			if(temp == 9 ){
				bonus_count++;
			}
			else if (temp == 7){
				lucky_arry[lucky_count] = Row5sPos[i];
				lucky_count++;
			}
			else if (temp == 8){//bonus
				bonus_arry[bonus_count] = Row5sPos[i];
				
				bonus_count++;
			}
			else if(temp == 10){// wild
				
				//	Row5sPos[i].transform.Find("symbol_ani").gameObject.GetComponent<Animator>().SetInteger("status", 3);
				
				wild_arry[wild_count] = Row5sPos[i];
				wild_count++;
				
			}
			
			i++;
		}
		
		StartCoroutine( symbol_ani_start());

	}


	IEnumerator symbol_ani_start(){
	//	yield return new WaitForSeconds(0.5f);
	
		if(lucky_count >= how_many_lucky && spinButtonImg.sprite.name == "image_button_spin" && glinda_duration == false){
			lucky_count_txt.text = lucky_count.ToString();
			lucky_start_notice.SetActive(true);
			for(int p = 0; p < lucky_arry.Length; p++) 
			{
				if (lucky_arry[p] != null){
					lucky_arry[p].transform.Find("symbol_ani").GetComponent<Animator>().SetInteger("status", 1);
				}    
			}
			
			autospin_cnt = how_many_lucky;
			//Debug.Log("autospin_cnt : "+ autospin_cnt);
			if( autospin_cnt >= -1 ){	// if button is not autospin
				yield return new WaitForSeconds(1.5f);
				StartCoroutine(start_lucky(lucky_count));					

			}
			else
				autospin_cnt = 0;
		}
		
		
		
		if(bonus_count >= how_many_bonus){
		//	Debug.Log("good enough to b bonus" + bonus_count);
			
			scorePage.set_small_txt("Bonus Game Start !");
			bonus_start_notice.SetActive(true);

			scorePage.WIN = 0;
			StartCoroutine(movecameraPage.moveCameraToBonus());


			for(int p = 0; p < bonus_arry.Length; p++) {
				
				if(bonus_arry[p] != null){
					bonus_arry[p].transform.Find("symbol_ani").GetComponent<Animator>().SetInteger("status", 2);
					
				}
			}
		}
		
		if(wild_count >= 0){
			
			//Debug.Log("wild count " + wild_count);
			
			for(int p = 0; p < wild_arry.Length; p++) {
				
				if(wild_arry[p] != null){
					wild_arry[p].transform.Find("symbol_ani").GetComponent<Animator>().SetInteger("status", 3);
					
				}
			}
		}

		yield return new WaitForSeconds(1.0f);
		bonus_start_notice.SetActive(false);
		lucky_start_notice.SetActive(false);
		StartCoroutine(is_level_up());
	}

	
	void all_anim_stop(){
		//Debug.Log("all anim stop");
		for(int p = 0; p < lucky_count; p++) 
			lucky_arry[p] = null;
		
		for(int p = 0; p < bonus_count; p++) 
			bonus_arry[p] = null;	

		for(int p = 0; p < wild_count; p++) 
			wild_arry[p] = null;

		foreach(GameObject go in symbol_anis){
			go.GetComponent<Animator>().SetInteger("status", 0);
			
		}

		lucky_count = 0;
		bonus_count = 0;

		glindaPage.superWilds[1].SetActive(false);
		glindaPage.superWilds[2].SetActive(false);
		glindaPage.superWilds[3].SetActive(false);
		glindaPage.superWilds[4].SetActive(false);

	}


	IEnumerator is_level_up(){

		if(exp_bar.value >= exp_bar.maxValue){
			Debug.Log("Spin Page - exp_bar reached the max value ");
			level_up_notice.SetActive(true);
			level_upPage.go_to_next_level();

		}
		//yield return new WaitForSeconds(4.0f);

		yield return new WaitForSeconds(8.0f);
		level_up_notice.SetActive(false);
	}

	public void disable_level_up_notice(){
		level_up_notice.SetActive(false);

	}
	
	public IEnumerator start_lucky(int times){
		
		ui_mini_Freespin.SetActive(true);
		soundPage.stop_all();
		spinButtonImg.sprite = autoButton;
		GameObject.Find("Spin").GetComponent<Button>().interactable = false;
		
		soundPage.lucky_sound_Clk_sound();
		yield return new WaitForSeconds(0.3f);

		autospin_cnt = times;

		while(autospin_cnt >= 0 &&  GameObject.Find("Main").activeSelf ){

			how_many_freespin.text = autospin_cnt.ToString();

			if(game_camera.transform.position == new Vector3(0, 0,-15)){ // when no bonus
				
				if(GameObject.Find("Main").activeSelf){

				}
				else{
					Debug.Log("break");
					break;
					
				}

				Spin_Clicked();
				
			}
			
			yield return new WaitForSeconds(6.0f);


			autospin_cnt--;
		}



		ui_mini_Freespin.SetActive(false);
		if(how_many_freespin.text == "0")
			how_many_freespin.text = "";


		soundPage.stop_all();
		yield return new WaitForSeconds(0.3f);
		soundPage.bg_sound_Clk_Sound();
	}


	public IEnumerator glinda_counter_func(){
		glinda_duration = true;
		GameObject.Find("Spin").GetComponent<Button>().interactable = false;
		
		if(glinda_count >= set_glinda_count){
			glindaPage.enable_glinda();
			
			spinningTime5 = 11.5f;
			spinningTime4 = 8.0f;
			spinningTime3 = 7.5f;
			spinningTime2 = 7.0f;
			spinningTime1 = 6.5f;
			
			set_glinda_count = 12; //Random.Range(glinda_min,glinda_max);
			glinda_count = 0;
		}
		yield return new WaitForSeconds(18.0f);
		glinda_duration = false;
	}


	public void disable_notice(){
		
		lucky_start_notice.SetActive(false);	
		bonus_start_notice.SetActive(false);
		
	}

}
