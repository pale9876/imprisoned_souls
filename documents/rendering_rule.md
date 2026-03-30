# 렌더링 규칙


 이 프레임워크에 존재하는 객체 EndekaRenderer / EEAD 2D, 노드2D를 상속하는 두 클래스는 느슨한 렌더링 규칙을 가지고 있습니다.

 두 객체는 가장 후미에 위치한 노드는 가장 위에 그려진다는 기존의 렌더링 규칙은 따르되, 내부 노드는 z값을 통하여 정렬 후 드로잉을 시전합니다.

 해당 프레임워크는 정수가 아닌 실수 Z축을 가진 Node2D 객체인 EEAD2D 또는 EndekaRenderItem Sprite2D 객체 대신 다양한 형태의 렌더링 기능을 수행할 수 있습니다.<br/><br/>
EEAD2D는 EndekaRenderer(엔데카 렌더러)를 통하여 Z축 렌더링이 수행됩니다. 없다면 씬트리에 기반하여 일반적인 렌더링을 수행합니다.<br/><br/>
EndekaRenderer는 EndekaRenderingItem의 z 값을 기준으로 오름차순 정렬 후, 순차적으로 렌더링을 수행하고 z축이 가장 큰 정보를 마지막으로 렌더링합니다.<br/><br/>

---

 EEAD2D? EndekaRenderItem? EndekaRenderer?

 

