@tool
extends Node2D
class_name EndekaRenderer


# HACK
# 하위 EEAD의 Z값 변화에 따라 EndekaRenderItem을 내림차순으로 정렬하고
# EndekaRenderItem 오브젝트들을 드로우합니다.
# 성능에 문제가 있는지는 아직 확인되지 않았습니다.
