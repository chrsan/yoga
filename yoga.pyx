# cython: language_level=3

from enum import IntEnum

from libc.stddef cimport size_t
from libc.stdint cimport uintptr_t

cdef extern from *:
    struct YGNode:
        pass

    ctypedef YGNode* YGNodeRef

    ctypedef const YGNode* YGNodeConstRef


cdef extern from "yoga/YGEnums.h":
    enum YGAlign:
        pass

    enum YGDirection:
        pass

    enum YGDisplay:
        pass

    enum YGEdge:
        pass

    enum YGFlexDirection:
        pass

    enum YGGutter:
        pass

    enum YGJustify:
        pass

    enum YGOverflow:
        pass

    enum YGPositionType:
        pass

    enum YGUnit:
        pass

    enum YGWrap:
        pass


cdef extern from "yoga/YGConfig.h":
    struct YGConfig:
        pass

    ctypedef YGConfig* YGConfigRef

    ctypedef const YGConfig* YGConfigConstRef

    YGConfigRef YGConfigNew()

    void YGConfigFree(YGConfigRef config)

    void YGConfigSetUseWebDefaults(YGConfigRef config, bint enabled)

    bint YGConfigGetUseWebDefaults(YGConfigConstRef config)

    void YGConfigSetPointScaleFactor(YGConfigRef config, float pixels_in_point)

    float YGConfigGetPointScaleFactor(YGConfigConstRef config)


cdef class Config:
    cdef YGConfigRef _ref

    def __cinit__(self) -> None:
        self._ref = YGConfigNew()
        if self._ref is NULL:
            raise MemoryError()

    def __dealloc_(self) -> None:
        if self._ref is not NULL:
            YGConfigFree(self._ref)
            self._ref = NULL

    @property
    def use_web_defaults(self) -> bool:
        return YGConfigGetUseWebDefaults(self._ref)

    @use_web_defaults.setter
    def use_web_defaults(self, enabled: bool) -> None:
        YGConfigSetUseWebDefaults(self._ref, enabled)

    @property
    def point_scale_factor(self) -> float:
        return YGConfigGetPointScaleFactor(self._ref)

    @point_scale_factor.setter
    def point_scale_factor(self, pixels_in_point: float) -> None:
        YGConfigSetPointScaleFactor(self._ref, pixels_in_point)


class Direction(IntEnum):
    INHERIT = 0
    LTR = 1
    RTL = 2


class Edge(IntEnum):
    LEFT = 0
    TOP = 1
    RIGHT = 2
    BOTTOM = 3
    START = 4
    END = 5
    HORIZONTAL = 6
    VERTICAL = 7
    ALL = 8


cdef extern from "yoga/YGNodeLayout.h":
    float YGNodeLayoutGetLeft(YGNodeConstRef node)

    float YGNodeLayoutGetTop(YGNodeConstRef node)

    float YGNodeLayoutGetRight(YGNodeConstRef node)

    float YGNodeLayoutGetBottom(YGNodeConstRef node)

    float YGNodeLayoutGetWidth(YGNodeConstRef node)

    float YGNodeLayoutGetHeight(YGNodeConstRef node)

    YGDirection YGNodeLayoutGetDirection(YGNodeConstRef node)

    bint YGNodeLayoutGetHadOverflow(YGNodeConstRef node);

    float YGNodeLayoutGetMargin(YGNodeConstRef node, YGEdge edge)

    float YGNodeLayoutGetBorder(YGNodeConstRef node, YGEdge edge)

    float YGNodeLayoutGetPadding(YGNodeConstRef node, YGEdge edge)


cdef class Layout:
    cdef YGNodeRef _ref

    def __dealloc__(self) -> None:
        self._ref = NULL

    def __init__(self) -> None:
        raise TypeError("This class cannot be instantiated directly.")

    @property
    def left(self) -> float:
        return YGNodeLayoutGetLeft(self._ref)

    @property
    def top(self) -> float:
        return YGNodeLayoutGetTop(self._ref)

    @property
    def right(self) -> float:
        return YGNodeLayoutGetRight(self._ref)

    @property
    def bottom(self) -> float:
        return YGNodeLayoutGetBottom(self._ref)

    @property
    def width(self) -> float:
        return YGNodeLayoutGetWidth(self._ref)

    @property
    def height(self) -> float:
        return YGNodeLayoutGetHeight(self._ref)

    @property
    def direction(self) -> Direction:
        return Direction(YGNodeLayoutGetDirection(self._ref))

    @property
    def had_overflow(self) -> bool:
        return YGNodeLayoutGetHadOverflow(self._ref)

    def margin(self, edge: Edge) -> float:
        assert edge <= Edge.END
        return YGNodeLayoutGetMargin(self._ref, edge)

    def border(self, edge: Edge) -> float:
        assert edge <= Edge.END
        return YGNodeLayoutGetBorder(self._ref, edge)

    def padding(self, edge: Edge) -> float:
        assert edge <= Edge.END
        return YGNodeLayoutGetPadding(self._ref, edge)


class Unit(IntEnum):
    UNDEFINED = 0
    POINT = 1
    PERCENT = 2
    AUTO = 3


cdef extern from "yoga/YGValue.h":
    ctypedef struct YGValue:
        float value
        YGUnit unit


cdef extern from "yoga/YGNodeStyle.h":
    void YGNodeCopyStyle(YGNodeRef dst_node, YGNodeConstRef src_node);

    YGDirection YGNodeStyleGetDirection(YGNodeConstRef node)

    void YGNodeStyleSetDirection(YGNodeRef node, YGDirection direction)

    YGFlexDirection YGNodeStyleGetFlexDirection(YGNodeConstRef node)

    void YGNodeStyleSetFlexDirection(YGNodeRef node, YGFlexDirection flex_direction)

    YGJustify YGNodeStyleGetJustifyContent(YGNodeConstRef node)

    void YGNodeStyleSetJustifyContent(YGNodeRef node, YGJustify justify_content)

    YGAlign YGNodeStyleGetAlignContent(YGNodeConstRef node)

    void YGNodeStyleSetAlignContent(YGNodeRef node, YGAlign align_content)

    YGAlign YGNodeStyleGetAlignItems(YGNodeConstRef node)

    void YGNodeStyleSetAlignItems(YGNodeRef node, YGAlign align_items)

    YGAlign YGNodeStyleGetAlignSelf(YGNodeConstRef node)

    void YGNodeStyleSetAlignSelf(YGNodeRef node, YGAlign align_self)

    YGPositionType YGNodeStyleGetPositionType(YGNodeConstRef node)

    void YGNodeStyleSetPositionType(YGNodeRef node, YGPositionType position_type)

    YGWrap YGNodeStyleGetFlexWrap(YGNodeConstRef node)

    void YGNodeStyleSetFlexWrap(YGNodeRef node, YGWrap flex_wrap)

    YGOverflow YGNodeStyleGetOverflow(YGNodeConstRef node)

    void YGNodeStyleSetOverflow(YGNodeRef node, YGOverflow overflow)

    YGDisplay YGNodeStyleGetDisplay(YGNodeConstRef node)

    void YGNodeStyleSetDisplay(YGNodeRef node, YGDisplay display)

    float YGNodeStyleGetFlex(YGNodeConstRef node);

    void YGNodeStyleSetFlex(YGNodeRef node, float flex);

    float YGNodeStyleGetFlexGrow(YGNodeConstRef node)

    void YGNodeStyleSetFlexGrow(YGNodeRef node, float flex_grow)

    float YGNodeStyleGetFlexShrink(YGNodeConstRef node)

    void YGNodeStyleSetFlexShrink(YGNodeRef node, float flex_shrink)

    YGValue YGNodeStyleGetFlexBasis(YGNodeConstRef node)

    void YGNodeStyleSetFlexBasis(YGNodeRef node, float flex_basis)

    void YGNodeStyleSetFlexBasisPercent(YGNodeRef node, float flex_basis)

    void YGNodeStyleSetFlexBasisAuto(YGNodeRef node);

    YGValue YGNodeStyleGetPosition(YGNodeConstRef node, YGEdge edge)

    void YGNodeStyleSetPosition(YGNodeRef node, YGEdge edge, float position)
    
    void YGNodeStyleSetPositionPercent(YGNodeRef node, YGEdge edge, float position)

    YGValue YGNodeStyleGetMargin(YGNodeConstRef node, YGEdge edge)

    void YGNodeStyleSetMargin(YGNodeRef node, YGEdge edge, float margin)

    void YGNodeStyleSetMarginPercent(YGNodeRef node, YGEdge edge, float margin)

    void YGNodeStyleSetMarginAuto(YGNodeRef node, YGEdge edge)

    YGValue YGNodeStyleGetPadding(YGNodeConstRef node, YGEdge edge)

    void YGNodeStyleSetPadding(YGNodeRef node, YGEdge edge, float padding)

    void YGNodeStyleSetPaddingPercent(YGNodeRef node, YGEdge edge, float padding)

    float YGNodeStyleGetBorder(YGNodeConstRef node, YGEdge edge)

    void YGNodeStyleSetBorder(YGNodeRef node, YGEdge edge, float border)

    float YGNodeStyleGetGap(YGNodeConstRef node, YGGutter gutter)

    void YGNodeStyleSetGap(YGNodeRef node, YGGutter gutter, float gap_length)

    YGValue YGNodeStyleGetWidth(YGNodeConstRef node)

    void YGNodeStyleSetWidth(YGNodeRef node, float width)

    void YGNodeStyleSetWidthPercent(YGNodeRef node, float width)

    void YGNodeStyleSetWidthAuto(YGNodeRef node)

    YGValue YGNodeStyleGetHeight(YGNodeConstRef node)

    void YGNodeStyleSetHeight(YGNodeRef node, float height)

    void YGNodeStyleSetHeightPercent(YGNodeRef node, float height)

    void YGNodeStyleSetHeightAuto(YGNodeRef node)

    YGValue YGNodeStyleGetMinWidth(YGNodeConstRef node)

    void YGNodeStyleSetMinWidth(YGNodeRef node, float min_width)

    void YGNodeStyleSetMinWidthPercent(YGNodeRef node, float min_width)

    YGValue YGNodeStyleGetMinHeight(YGNodeConstRef node)

    void YGNodeStyleSetMinHeight(YGNodeRef node, float min_height)

    void YGNodeStyleSetMinHeightPercent(YGNodeRef node, float min_height)

    YGValue YGNodeStyleGetMaxWidth(YGNodeConstRef node)

    void YGNodeStyleSetMaxWidth(YGNodeRef node, float max_width)

    void YGNodeStyleSetMaxWidthPercent(YGNodeRef node, float max_width)

    YGValue YGNodeStyleGetMaxHeight(YGNodeConstRef node)

    void YGNodeStyleSetMaxHeight(YGNodeRef node, float max_height)

    void YGNodeStyleSetMaxHeightPercent(YGNodeRef node, float max_height)

    float YGNodeStyleGetAspectRatio(YGNodeConstRef node)

    void YGNodeStyleSetAspectRatio(YGNodeRef node, float aspect_ratio)


class FlexDirection(IntEnum):
    COLUMN = 0
    COLUMN_REVERSE = 1
    ROW = 2
    ROW_REVERSE = 3


class Justify(IntEnum):
    FLEX_START = 0
    CENTER = 1
    FLEX_END = 2
    SPACE_BETWEEN = 3
    SPACE_AROUND = 4
    SPACE_EVENLY = 5


class Align(IntEnum):
    AUTO = 0
    FLEX_START = 1
    CENTER = 2
    FLEX_END = 3
    STRETCH = 4
    BASELINE = 5
    SPACE_BETWEEN = 6
    SPACE_AROUND = 7
    SPACE_EVENLY = 8


class PositionType(IntEnum):
    STATIC = 0
    RELATIVE = 1
    ABSOLUTE = 2


class Wrap(IntEnum):
    NO_WRAP = 0
    WRAP = 1
    WRAP_REVERSE = 2


class Overflow(IntEnum):
    VISIBLE = 0
    HIDDEN = 1
    SCROLL = 2


class Display(IntEnum):
    FLEX = 0
    NONE = 1


class Gutter(IntEnum):
    COLUMN = 0
    ROW = 1
    ALL = 2


cdef extern from "yoga/YGNode.h":
    YGNodeRef YGNodeNew()

    YGNodeRef YGNodeNewWithConfig(YGConfigConstRef config)

    void YGNodeFree(YGNodeRef node)

    void YGNodeReset(YGNodeRef node)

    void YGNodeCalculateLayout(YGNodeRef node,
                               float available_width,
                               float available_height,
                               YGDirection owner_direction)

    bint YGNodeGetHasNewLayout(YGNodeConstRef node)

    void YGNodeSetHasNewLayout(YGNodeRef node, bint has_new_layout)

    bint YGNodeIsDirty(YGNodeConstRef node)

    void YGNodeMarkDirty(YGNodeRef node)

    void YGNodeInsertChild(YGNodeRef node, YGNodeRef child, size_t index)

    void YGNodeRemoveChild(YGNodeRef node, YGNodeRef child)

    void YGNodeRemoveAllChildren(YGNodeRef node)

    YGNodeRef YGNodeGetChild(YGNodeRef node, size_t index)

    size_t YGNodeGetChildCount(YGNodeConstRef node)

    YGNodeRef YGNodeGetParent(YGNodeRef node)

    bint YGNodeIsReferenceBaseline(YGNodeConstRef node)

    void YGNodeSetIsReferenceBaseline(YGNodeRef node, bint is_reference_baseline)

    bint YGNodeGetAlwaysFormsContainingBlock(YGNodeConstRef node)

    void YGNodeSetAlwaysFormsContainingBlock(YGNodeRef node, bint always_forms_containing_block)


cdef class Node:
    _mappings = {}

    cdef YGNodeRef _ref

    def __cinit__(self, Config config = None) -> None:
        if config is None:
            self._ref = YGNodeNew()
        else:
            self._ref = YGNodeNewWithConfig(config._ref)
        if self._ref is NULL:
            raise MemoryError()
        cdef uintptr_t addr = <uintptr_t>self._ref
        self._mappings[addr] = self

    def __dealloc_(self) -> None:
        if self._ref is not NULL:
            YGNodeFree(self._ref)
            self._ref = NULL

    def __del__(self) -> None:
        cdef uintptr_t addr = <uintptr_t>self._ref
        del self._mappings[addr]

    def reset(self) -> None:
        YGNodeReset(self._ref)

    def calculate_layout(self, available_width: int, available_height: int,
                         owner_direction: Direction) -> None:
        YGNodeCalculateLayout(self._ref, available_width, available_height,
                              owner_direction)

    @property
    def has_new_layout(self) -> bool:
        return YGNodeGetHasNewLayout(self._ref)

    @has_new_layout.setter
    def has_new_layout(self, has_new_layout: bool) -> None:
        YGNodeSetHasNewLayout(self._ref, has_new_layout)

    def is_dirty(self) -> bool:
        return YGNodeIsDirty(self._ref)

    def mark_dirty(self) -> None:
        YGNodeMarkDirty(self._ref)

    # TODO: Dirtied callback.

    def remove_child(self, child: Node) -> None:
        YGNodeRemoveChild(self._ref, child._ref)

    def __getitem__(self, index: int) -> Node | None:
        ref = YGNodeGetChild(self._ref, index)
        if ref is NULL:
            return None
        cdef uintptr_t addr = <uintptr_t>ref
        return self._mappings[addr]

    def __setitem__(self, index: int, child: Node) -> None:
        assert child is not self
        YGNodeInsertChild(self._ref, child._ref, index)

    def __delitem__(self, child: Node) -> None:
        YGNodeRemoveChild(self._ref, child._ref)

    def __len__(self) -> int:
        return YGNodeGetChildCount(self._ref)

    def clear(self) -> None:
        YGNodeRemoveAllChildren(self._ref)

    @property
    def parent(self) -> Node | None:
        ref = YGNodeGetParent(self._ref)
        if ref is NULL:
            return None
        cdef uintptr_t addr = <uintptr_t>ref
        return self._mappings[addr]

    @property
    def is_reference_baseline(self) -> bool:
        return YGNodeIsReferenceBaseline(self._ref)

    @is_reference_baseline.setter
    def is_reference_baseline(self, is_reference_baseline: bool) -> None:
        YGNodeSetIsReferenceBaseline(self._ref, is_reference_baseline)

    @property
    def always_forms_containing_block(self) -> bool:
        return YGNodeGetAlwaysFormsContainingBlock(self._ref)

    @always_forms_containing_block.setter
    def always_forms_containing_block(self, always_forms_containing_block: bool) -> None:
        YGNodeSetAlwaysFormsContainingBlock(self._ref, always_forms_containing_block)

    @property
    def layout(self) -> Layout:
        cdef Layout layout = Layout.__new__(Layout)
        layout._ref = self._ref
        return layout

    def copy_style(self, dst: Node) -> None:
        YGNodeCopyStyle(dst._ref, self._ref)

    @property
    def direction(self) -> Direction:
        return YGNodeStyleGetDirection(self._ref)

    @direction.setter
    def direction(self, direction: Direction) -> None:
        YGNodeStyleSetDirection(self._ref, direction)

    @property
    def flex_direction(self) -> FlexDirection:
        return YGNodeStyleGetFlexDirection(self._ref)

    @flex_direction.setter
    def flex_direction(self, flex_direction: FlexDirection) -> None:
        YGNodeStyleSetFlexDirection(self._ref, flex_direction)

    @property
    def justify_content(self) -> Justify:
        return YGNodeStyleGetJustifyContent(self._ref)

    @justify_content.setter
    def justify_content(self, justify_content: Justify) -> None:
        YGNodeStyleSetJustifyContent(self._ref, justify_content)

    @property
    def align_content(self) -> Align:
        return YGNodeStyleGetAlignContent(self._ref)

    @align_content.setter
    def align_content(self, align_content: Align) -> None:
        YGNodeStyleSetAlignContent(self._ref, align_content)

    @property
    def align_items(self) -> Align:
        return YGNodeStyleGetAlignItems(self._ref)

    @align_items.setter
    def align_items(self, align_items: Align) -> None:
        YGNodeStyleSetAlignItems(self._ref, align_items)

    @property
    def align_self(self) -> Align:
        return YGNodeStyleGetAlignSelf(self._ref)

    @align_self.setter
    def align_self(self, align_self: Align) -> None:
        YGNodeStyleSetAlignSelf(self._ref, align_self)

    @property
    def position_type(self) -> PositionType:
        return YGNodeStyleGetPositionType(self._ref)

    @position_type.setter
    def position_type(self, position_type: PositionType) -> None:
        YGNodeStyleSetPositionType(self._ref, position_type)

    @property
    def flex_wrap(self) -> Wrap:
        return YGNodeStyleGetFlexWrap(self._ref)

    @flex_wrap.setter
    def flex_wrap(self, flex_wrap: Wrap) -> None:
        YGNodeStyleSetFlexWrap(self._ref, flex_wrap)

    @property
    def overflow(self) -> Overflow:
        return YGNodeStyleGetOverflow(self._ref)

    @overflow.setter
    def overflow(self, overflow: Overflow) -> None:
        YGNodeStyleSetOverflow(self._ref, overflow)

    @property
    def display(self) -> Display:
        return YGNodeStyleGetDisplay(self._ref)

    @display.setter
    def display(self, display: Display) -> None:
        YGNodeStyleSetDisplay(self._ref, display)

    @property
    def flex(self) -> float:
        return YGNodeStyleGetFlex(self._ref)

    @flex.setter
    def flex(self, flex: float) -> None:
        YGNodeStyleSetFlex(self._ref, flex)

    @property
    def flex_grow(self) -> float:
        return YGNodeStyleGetFlexGrow(self._ref)

    @flex_grow.setter
    def flex_grow(self, flex_grow: float) -> None:
        YGNodeStyleSetFlexGrow(self._ref, flex_grow)

    @property
    def flex_shrink(self) -> float:
        return YGNodeStyleGetFlexShrink(self._ref)

    @flex_shrink.setter
    def flex_shrink(self, flex_shrink: float) -> None:
        YGNodeStyleSetFlexShrink(self._ref, flex_shrink)

    @property
    def flex_basis(self) -> tuple[float, Unit]:
        cdef YGValue value = YGNodeStyleGetFlexBasis(self._ref)
        return value.value, Unit(value.unit)

    @flex_basis.setter
    def flex_basis(self, flex_basis: float) -> None:
        YGNodeStyleSetFlexBasis(self._ref, flex_basis)

    def set_flex_basis_percent(self, flex_basis: float) -> None:
        YGNodeStyleSetFlexBasisPercent(self._ref, flex_basis)

    def set_flex_basis_auto(self) -> None:
        YGNodeStyleSetFlexBasisAuto(self._ref)

    def position(self, edge: Edge) -> tuple[float, Unit]:
        cdef YGValue value = YGNodeStyleGetPosition(self._ref, edge)
        return value.value, Unit(value.unit)

    def set_position(self, edge: Edge, position: float) -> None:
        YGNodeStyleSetPosition(self._ref, edge, position)

    def set_position_percent(self, edge: Edge, position: float) -> None:
        YGNodeStyleSetPositionPercent(self._ref, edge, position)

    def margin(self, edge: Edge) -> tuple[float, Unit]:
        cdef YGValue value = YGNodeStyleGetMargin(self._ref, edge)
        return value.value, Unit(value.unit)

    def set_margin(self, edge: Edge, margin: float) -> None:
        YGNodeStyleSetMargin(self._ref, edge, margin)

    def set_margin_percent(self, edge: Edge, margin: float) -> None:
        YGNodeStyleSetMarginPercent(self._ref, edge, margin)

    def set_margin_auto(self, edge: Edge) -> None:
        YGNodeStyleSetMarginAuto(self._ref, edge)

    def padding(self, edge: Edge) -> tuple[float, Unit]:
        cdef YGValue value = YGNodeStyleGetPadding(self._ref, edge)
        return value.value, Unit(value.unit)

    def set_padding(self, edge: Edge, padding: float) -> None:
        YGNodeStyleSetPadding(self._ref, edge, padding)

    def set_padding_percent(self, edge: Edge, padding: float) -> None:
        YGNodeStyleSetPaddingPercent(self._ref, edge, padding)

    def border(self, edge: Edge) -> float:
        return YGNodeStyleGetBorder(self._ref, edge)

    def set_border(self, edge: Edge, border: float) -> None:
        YGNodeStyleSetBorder(self._ref, edge, border)

    def gap(self, gutter: Gutter) -> float:
        return YGNodeStyleGetGap(self._ref, gutter)

    def set_gap(self, gutter: Gutter, gap_length: float) -> None:
        YGNodeStyleSetGap(self._ref, gutter, gap_length)

    @property
    def width(self) -> tuple[float, Unit]:
        cdef YGValue value = YGNodeStyleGetWidth(self._ref)
        return value.value, Unit(value.unit)

    @width.setter
    def width(self, width: float) -> None:
        YGNodeStyleSetWidth(self._ref, width)

    def set_width_percent(self, width: float) -> None:
        YGNodeStyleSetWidthPercent(self._ref, width)

    def set_width_auto(self) -> None:
        YGNodeStyleSetWidthAuto(self._ref)

    @property
    def height(self) -> tuple[float, Unit]:
        cdef YGValue value = YGNodeStyleGetHeight(self._ref)
        return value.value, Unit(value.unit)

    @height.setter
    def height(self, height: float) -> None:
        YGNodeStyleSetHeight(self._ref, height)

    def set_height_percent(self, height: float) -> None:
        YGNodeStyleSetHeightPercent(self._ref, height)

    def set_height_auto(self) -> None:
        YGNodeStyleSetHeightAuto(self._ref)

    @property
    def min_width(self) -> tuple[float, Unit]:
        cdef YGValue value = YGNodeStyleGetMinWidth(self._ref)
        return value.value, Unit(value.unit)

    @min_width.setter
    def min_width(self, min_width: float) -> None:
        YGNodeStyleSetMinWidth(self._ref, min_width)

    def set_min_width_percent(self, min_width: float) -> None:
        YGNodeStyleSetMinWidthPercent(self._ref, min_width)

    @property
    def min_height(self) -> tuple[float, Unit]:
        cdef YGValue value = YGNodeStyleGetMinHeight(self._ref)
        return value.value, Unit(value.unit)

    @min_height.setter
    def min_height(self, min_height: float) -> None:
        YGNodeStyleSetMinHeight(self._ref, min_height)

    def set_min_height_percent(self, min_height: float) -> None:
        YGNodeStyleSetMinHeightPercent(self._ref, min_height)

    @property
    def max_width(self) -> tuple[float, Unit]:
        cdef YGValue value = YGNodeStyleGetMaxWidth(self._ref)
        return value.value, Unit(value.unit)

    @max_width.setter
    def max_width(self, max_width: float) -> None:
        YGNodeStyleSetMaxWidth(self._ref, max_width)

    def set_max_width_percent(self, max_width: float) -> None:
        YGNodeStyleSetMaxWidthPercent(self._ref, max_width)

    @property
    def max_height(self) -> tuple[float, Unit]:
        cdef YGValue value = YGNodeStyleGetMaxHeight(self._ref)
        return value.value, Unit(value.unit)

    @max_height.setter
    def max_height(self, max_height: float) -> None:
        YGNodeStyleSetMaxHeight(self._ref, max_height)

    def set_max_height_percent(self, max_height: float) -> None:
        YGNodeStyleSetMaxHeightPercent(self._ref, max_height)

    @property
    def aspect_ratio(self) -> float:
        return YGNodeStyleGetAspectRatio(self._ref)

    @aspect_ratio.setter
    def aspect_ratio(self, aspect_ratio: float) -> None:
        YGNodeStyleSetAspectRatio(self._ref, aspect_ratio)
