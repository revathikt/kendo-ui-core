using Microsoft.AspNetCore.Razor.TagHelpers;
using System.Threading.Tasks;

namespace Kendo.Mvc.TagHelpers
{
    /// <summary>
    /// Kendo UI UploadFile TagHelper
    /// </summary>
    [HtmlTargetElement("kendo-upload-file", ParentTag="kendo-upload-files", TagStructure=TagStructure.WithoutEndTag)]
    [SupressTagRendering]
    public partial class UploadFileTagHelper : TagHelperCollectionItemBase
    {
        public UploadFileTagHelper() : base()
        {
        }

        public override async Task ProcessAsync(TagHelperContext context, TagHelperOutput output)
        {
            await base.ProcessAsync(context, output);
        }

        protected override void AddSelfToParent(TagHelperContext context)
        {
            var parent = typeof(UploadFilesTagHelper);
            if (context.Items.ContainsKey(parent))
            {
                (context.Items[parent] as UploadFilesTagHelper).Add(this);
            }
        }
    }
}

