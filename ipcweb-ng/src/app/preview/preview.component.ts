import { Component, OnInit, AfterViewInit, OnDestroy, ViewChild, ElementRef } from '@angular/core';
import { ViewEncapsulation } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { ConfigService } from '../config.service';
import Logger from '../logger';
import { ResponseErrorService } from 'src/app/shared/func-service/response-error.service';
import { TipsService } from 'src/app/tips/tips.service';
import { DiyHttpService } from 'src/app/shared/func-service/diy-http.service';

@Component({
  selector: 'app-preview',                 //关联选择器名
  templateUrl: './preview.component.html', //关联preview页面
  styleUrls: ['./preview.component.scss'], //关联scss渲染
  encapsulation: ViewEncapsulation.None 
  //这定义了组件的样式封装模式。Angular 提供三种样式封装策略：Emulated（默认）、None 和 ShadowDom。
  //ViewEncapsulation.None 表示组件的样式不会被封装,到处都可以用不止在preview Component组件里使用
  //它们将被全局应用，影响整个应用中的所有元素。这通常用于当你想要强制全局样式或当你使用某些 CSS 库和框架时。
})

export class PreviewComponent implements OnInit, AfterViewInit, OnDestroy {

  // ViewChild 装饰器，用于访问子组件、指令或 DOM 元素。
  //子组件在html里叫player
  //在这叫playerChild
  //写了这句话,在这里就能操作player里的方法
  @ViewChild('player', {static: true}) playerChild: any;

  constructor(
    private cfgService: ConfigService,      // 配置服务。
    private fb: FormBuilder,                // FormBuilder 用于创建表单。
    private resError: ResponseErrorService, // 错误处理服务。
    private tips: TipsService,              // 用户通知提示服务。
    private dhs: DiyHttpService,            // 自定义后端交互的 HTTP 服务。
  ) { }         

  private logger: Logger = new Logger('config');// Logger 实例用于记录日志。
  private src: string;                          // 私有变量，用于存储视频源 URL。
  private isViewInit: boolean = false;          // 标志，检查视图是否初始化。
  isPTZEnabled: boolean = true;                 // 公共标志，启用/禁用 PTZ 控制。
  private urlOb: any;                           // 用于保存 URL 可观察对象的订阅。

  playerOption = {  // 播放器组件的选项。
    isReshape: false,
    speName: 'preview', //样式名
  };

  // 测试连接的反应式表单定义。
  testForm = this.fb.group({
    url: 'ws://172.16.21.151:8081',
  });

  //PTX控制的方向数组
  directions = [
    'left-up', 'up', 'right-up',
    'left', 'auto', 'right',
    'left-down', 'down', 'right-down'
  ];

  //相关摄像头控制的操作数组
  operations = [
    'zoom',
    'focus',
    'iris'
  ];

  // 生命周期钩子，Angular 初始化所有数据绑定属性后调用。
  ngOnInit() {
    this.urlOb = this.dhs.getStreamUrl().subscribe(
      (msg: string) => {
        if (msg) {
          this.src = msg; // 设置视频源 URL。
          this.playEntry(); // 播放视频。
        } else {
          this.tips.setRbTip('getVideoUrlFail'); // 如果获取 URL 失败，则通知用户。
        }
        this.urlOb.unsubscribe(); // 清理订阅。
        this.urlOb = null; // 将订阅引用设为 null。
      }
    );
  }

  ngAfterViewInit() {
    this.isViewInit = true;          //设置视图初始化标志
    this.playerChild.set4Preview();  //为预览配置播放器
    this.playEntry();                //开始播放视频
  }

  // 生命周期钩子，Angular 销毁组件前调用。
  ngOnDestroy() {
    try {
      //停止子组件player播放器播放功能
      //子组件在html里叫player
      //在这叫playerChild
      this.playerChild.diyStop();
    } catch {}
  }

  //初始化视频播放函数
  playEntry() {
    if (this.isViewInit && this.src) { // 检查视图是否初始化并且源已设置。
      this.playerChild.displayUrl = this.src; // 在播放器中设置视频 URL。
      this.playerChild.bigBtnPlay(); // 触发大播放按钮播放视频。
    }
  }
  
  // 处理手动连接启动的函数。
  onConnect() {
    if (this.src) {
      this.playerChild.diyStop(); //停止任何现有的视频播放
    }
    if (this.urlOb) {
      this.urlOb.unsubscribe(); //清理订阅
    }
    this.src = this.testForm.value.url;//从列表中获取新的URL 并设置
    this.playEntry(); //再次开始播放时频
  }
}
