import { Component, OnInit, HostListener, AfterViewInit, ElementRef } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { AuthService } from 'src/app/auth/auth.service';
import { PublicFuncService } from 'src/app/shared/func-service/public-func.service';
import { LayoutService } from 'src/app/shared/func-service/layout.service';

@Component({
  selector: 'app-root',                 // 定义该组件的选择器，即HTML中使用的标签名
  templateUrl: './app.component.html',  // 指向组件的 HTML 模板文件
  styleUrls: ['./app.component.scss']   // 指向组件的样式文件
})

export class AppComponent implements OnInit, AfterViewInit { 
  //定义了AppComponet类,并实现了OnInit和AfterViewInit方法(接口)
  //OnInit方法处理组件初始化后的逻辑
  //AfterViewInit方法处理视图初始化后的逻辑

  constructor(//构造器
    public translate: TranslateService, // 注入翻译服务
    private auth: AuthService,          // 注入认证服务
    private pfs: PublicFuncService,     // 注入公共功能服务
    private los: LayoutService,         // 注入布局服务
    private el: ElementRef              // 注入元素引用，用于直接操作 DOM 元素
  ) {}

  title = 'ipcweb-ng';
  langBank = [
    'zh-CN',
    'en-US'
  ];

  public async ngOnInit() {
    this.los.getLayoutConfig();
    this.translate.setDefaultLang('zh-CN');
    let currentLanguage = await localStorage.getItem('currentLanguage') || this.translate.getBrowserCultureLang();
    if (!this.pfs.isInArrayString(this.langBank, currentLanguage)) {
      currentLanguage = 'zh-CN';
    }
    this.translate.use(currentLanguage);
    localStorage.setItem('currentLanguage', currentLanguage);
  }

  ngAfterViewInit() {
    this.los.getBrowserSize();
  }

  public selectLanguage(lang) {
    if (this.pfs.isInArrayString(this.langBank, lang)) {
      this.translate.use(lang);
      localStorage.setItem('currentLanguage', lang);
    }
  }

  @HostListener('window:resize', ['$event'])
  onResize(event) {
    this.los.getBrowserSize();
  }
}
